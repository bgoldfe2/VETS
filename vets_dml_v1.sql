-- author: Bruce Goldfeder --
-- date: 14 FEB 2022       -- 
-- project: VETS           --
-- Data Manipulation Language (DML) script --

-- Test Products table --
TRUNCATE TABLE products CASCADE;
INSERT INTO products (name, version, price, vnd_id, created) VALUES ( 'Product X', 'v2', '$1.25', 'Vendor Y', current_timestamp);
SELECT * FROM products;

-- Test People table --
TRUNCATE TABLE people CASCADE;
INSERT INTO people (f_name, l_name, org_name, email, phone_num, usr_category, created) 
VALUES ('Bruce', 'Goldfeder', 'ASET Partners', 'bruce.goldfeder@asetpartners.com', '7033047518', 'dia seta', current_timestamp);
SELECT * FROM people;