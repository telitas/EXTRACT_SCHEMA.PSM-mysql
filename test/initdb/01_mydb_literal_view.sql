CREATE OR REPLACE VIEW mydb.literal_view AS
SELECT
    123456789.123456 AS numeric_literal,
    0 AS integer_literal,
    9223372036854775807 AS bigint_literal,
    0E0 AS double_precision_literal,
    '1234567890' AS character_literal,
    N'1234567890' AS national_character_literal,
    0x00 AS binary_varying_literal,
    DATE '0001-01-01' AS date_literal,
    TIME '000:00:00' AS time_literal,
    TIMESTAMP '0001-01-01T00:00:00' AS timestamp_literal,
    NULL AS null_literal
;
