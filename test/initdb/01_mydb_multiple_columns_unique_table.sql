CREATE TABLE mydb.multiple_columns_unique_table (
    multiple_unique_column_1 CHARACTER VARYING(10),
    multiple_unique_column_2 CHARACTER VARYING(10),
    UNIQUE (multiple_unique_column_1, multiple_unique_column_2)
);
