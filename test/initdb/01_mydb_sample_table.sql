CREATE TABLE mydb.sample_table (
    product_id NUMERIC(8) PRIMARY KEY,
    product_code CHARACTER(12) NOT NULL UNIQUE,
    product_name CHARACTER VARYING(30),
    price NUMERIC(15, 3),
    on_sale BOOLEAN NOT NULL,
    registered_at TIMESTAMP NOT NULL,
    note TEXT
);