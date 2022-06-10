DROP FUNCTION IF EXISTS extract_table_as_json;
DROP FUNCTION IF EXISTS extract_table_as_json_in_current_schema;
DELIMITER $$
CREATE FUNCTION extract_table_as_json(table_name VARCHAR(64), schema_name VARCHAR(64)) RETURNS JSON
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'DESCRIPTION:
    Extract the table schema as JSON.(preview)
    
    This function is a preview.
    That is because JSON Schema is in draft.
    
PARAM: table_name VARCHAR(64)
    Target table name to extract the schema as JSON.
    
PARAM: schema_name VARCHAR(64)
    The name of the schema to search for the table.
    
RETURN: JSON
    Generated JSON Schema document.
    If the table is not found, it will be NULL.
    
VERSION: ${version}
    
LAST UPDATE: ${last_update}
    
LICENSE:
    Copyright (c) 2022 telitas
    This function is released under the MIT License.
    See the LICENSE.txt file or https://opensource.org/licenses/mit-license.php for details.'
BEGIN
	DECLARE generated_document JSON;
    
    WITH target_table(table_schema, table_name) AS (
        SELECT
            tbl.table_schema,
            tbl.table_name
        FROM information_schema.tables AS tbl
        WHERE
			    tbl.table_schema = schema_name
			AND tbl.table_name = table_name
    ),
    target_table_columns(ordinal_position, column_name, data_type, is_nullable, character_maximum_length, character_octet_length, numeric_precision, numeric_scale) AS (
        SELECT
            col.ordinal_position,
            col.column_name,
            col.data_type,
            col.is_nullable = 'YES',
            col.character_maximum_length,
            col.character_octet_length,
            col.numeric_precision,
            col.numeric_scale
        FROM target_table AS tbl
            INNER JOIN information_schema.columns AS col ON
                    tbl.table_schema = col.table_schema
                AND tbl.table_name = col.table_name
        ORDER BY ordinal_position
    ),
    target_table_constraints(constraint_name, constraint_type, columns_count, ordinal_position, column_name) AS (
		SELECT
			con.constraint_name,
			con.constraint_type,
            COUNT(*) OVER(PARTITION BY con.constraint_name),
			keycol.ordinal_position,
			keycol.column_name
		FROM target_table AS tbl
			INNER JOIN information_schema.table_constraints AS con ON
					tbl.table_schema = con.table_schema
				AND tbl.table_name = con.table_name
			INNER JOIN information_schema.key_column_usage AS keycol ON
					con.constraint_schema = keycol.constraint_schema
				AND con.constraint_name = keycol.constraint_name
    ),
    row_section(document) AS (
        SELECT json_objectagg(col.column_name,
            CASE col.data_type
                WHEN 'decimal' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'pattern', CASE
                            WHEN col.numeric_precision IS NULL THEN
                                '^-?(?:[0-9]+(?:\\.[0-9]*)?|\\.[0-9]+)$'
                            WHEN col.numeric_scale = 0 THEN
                                concat('^-?(?:0*[0-9]{1,', col.numeric_precision - col.numeric_scale, '}(?:\\.0*)?|\\.0+)$')
                            WHEN col.numeric_precision = col.numeric_scale THEN
                                concat('^-?(?:0+(?:\\.[0-9]{0,', col.numeric_scale, '}0*)?|\\.[0-9]{1,', col.numeric_scale, '}0*)$')
                            ELSE
                                concat('^-?(?:0*[0-9]{1,', col.numeric_precision - col.numeric_scale, '}(?:\\.[0-9]{0,', col.numeric_scale, '}0*)?|\\.[0-9]{1,', col.numeric_scale, '}0*)$')
                        END
                    )
                WHEN 'smallint' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('integer', 'null') ELSE json_extract(json_array('integer'), '$[0]') END,
                        'minimum', -32768,
                        'maximum', 32767
                    )
                WHEN 'int' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('integer', 'null') ELSE json_extract(json_array('integer'), '$[0]') END,
                        'minimum', -2147483648,
                        'maximum', 2147483647
                    )
                WHEN 'bigint' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('integer', 'null') ELSE json_extract(json_array('integer'), '$[0]') END,
                        'minimum', -9223372036854775808,
                        'maximum', 9223372036854775807
                    )
                WHEN 'double' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('number', 'null') ELSE json_extract(json_array('number'), '$[0]') END,
                        'minimum', -1.7976931348623157E+308,
                        'maximum', 1.7976931348623157E+308
                    )
                WHEN 'char' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'minLength', col.character_maximum_length,
                        'maxLength', col.character_maximum_length
                    )
                WHEN 'varchar' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'maxLength', col.character_maximum_length
                    )
                WHEN 'text' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END
                    )
                WHEN 'binary' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'pattern', '^(?:[0-9a-fA-F]{2})*$',
                        'minLength', 2 * col.character_maximum_length,
                        'maxLength', 2 * col.character_maximum_length
                    )
                WHEN 'varbinary' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'pattern', '^(?:[0-9a-fA-F]{2})*$',
                        'maxLength', 2 * col.character_maximum_length
                    )
                WHEN 'blob' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'pattern', '^(?:[0-9a-fA-F]{2})*$'
                    )
                WHEN 'tinyint' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('boolean', 'null') ELSE json_extract(json_array('boolean'), '$[0]') END
                    )
                WHEN 'date' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'format', 'date'
                    )
                WHEN 'time' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'pattern', '^-?(?:83[0-8]|8[0-2][0-9]|[0-7]?[0-9]{1,2}):[0-5]?[0-9]:[0-5]?[0-9](?:.[0-9]{1,6})?$'
                    )
                WHEN 'datetime' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'format', 'date-time',
                        'pattern', '^(?!.*([Zz]|[+-][0-9]{2}:[0-9]{2})).*$'
                    )
                WHEN 'timestamp' THEN
                    json_object(
                        'type', CASE WHEN col.is_nullable THEN json_array('string', 'null') ELSE json_extract(json_array('string'), '$[0]') END,
                        'format', 'date-time',
                        'pattern', '(?:[+-][0-9]{2}:[0-9]{2})$'
                    )
                ELSE
                    json_object()
            END
        ) FROM target_table_columns AS col
    ),
    required_section(document) AS (
        SELECT
            COALESCE(json_arrayagg(col.column_name), json_array())
        FROM target_table_columns AS col
        WHERE NOT col.is_nullable
    )
    SELECT CASE
        WHEN
            (SELECT count(*) FROM target_table AS tbl) = 0 THEN NULL
        ELSE
            json_object(
                '$schema', 'https://json-schema.org/draft/2019-09/schema#',
                '$id', concat('https://telitas.dev/extract_schema.psm/', (SELECT concat(tbl.table_schema, '/', tbl.table_name) FROM target_table AS tbl),'/schema#'),
                'type','array',
                'items', json_object(
                    '$ref', '#/definitions/row'
                ),
                'definitions', json_object(
                    'row', json_object(
                        'type', 'object',
                        'additionalProperties', false,
                        'properties', (SELECT rowsec.document FROM row_section AS rowsec),
                        'required', (SELECT reqsec.document FROM required_section AS reqsec)
                    )
                )
            )
        END
    INTO generated_document;
    
    RETURN generated_document;
END;
$$
CREATE FUNCTION extract_table_as_json_in_current_schema(table_name VARCHAR(64)) RETURNS JSON READS SQL DATA
COMMENT 'DESCRIPTION:
    Extract the table schema as JSON.(preview)
    
    This function is a preview.
    That is because JSON Schema is in draft.
    
PARAM: table_name VARCHAR(64)
    Target table name to extract the schema as JSON.
    The table is searchd from the current schema.
    
RETURN: JSON
    Generated JSON Schema document.
    If the table is not found, it will be NULL.
    
VERSION: ${version}
    
LAST UPDATE: ${last_update}
    
LICENSE:
    Copyright (c) 2022 telitas
    This function is released under the MIT License.
    See the LICENSE.txt file or https://opensource.org/licenses/mit-license.php for details.'
BEGIN
    RETURN extract_table_as_json(table_name, schema());
END;
$$
DELIMITER ;
