CREATE TABLE mydb.single_column_unique_table (
    single_unique_column CHARACTER VARYING(10),
    UNIQUE (single_unique_column)
);
