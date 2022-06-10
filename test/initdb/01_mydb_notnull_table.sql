CREATE TABLE mydb.notnull_table (
    character_varying_column CHARACTER VARYING(10) NOT NULL,
    character_large_object_column TEXT NOT NULL,
    binary_varying_column VARBINARY(10) NOT NULL,
    binary_large_object_column BLOB NOT NULL,
    not_supported_type_column BIT NOT NULL
);
