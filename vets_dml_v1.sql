-- author: Bruce Goldfeder --
-- date: 14 FEB 2022       -- 
-- project: VETS           --
-- Data Manipulation Language (DML) script --

-- Test Products table --
TRUNCATE TABLE vets.products CASCADE;
INSERT INTO vets.products (name, version, price, vnd_id, created) 
	VALUES ( 'Product X', 'v2', '$1.25', 'Vendor Y', current_timestamp);
SELECT * FROM vets.products;

-- Test People table --
TRUNCATE TABLE vets.people CASCADE;
INSERT INTO vets.people (f_name, l_name, org_name, email, phone_num, usr_category, created) 
	VALUES ('Bruce', 'Goldfeder', 'ASET Partners', 'bruce.goldfeder@asetpartners.com', '7033047518', 'dia seta', current_timestamp);
SELECT * FROM vets.people;

-- Test Communications table --
TRUNCATE TABLE vets.communications CASCADE;
INSERT INTO vets.communications (communicate_type, notes, link_url, comm_dtg, created) 
	VALUES ('email', 'These are the notes of the meeting.  The end.', 
			'http://google.com', '2021-06-22 20:44:52.134125', current_timestamp);
SELECT * FROM vets.communications;

-- Test Products_Communications XREF table --
TRUNCATE TABLE vets.products_communications CASCADE;
INSERT INTO vets.products_communications (pdct_id, comm_id, created) 
	VALUES (1, 1, current_timestamp);
SELECT * FROM vets.products_communications;

-- Test Products_Communications XREF table --
TRUNCATE TABLE vets.people_communications CASCADE;
INSERT INTO vets.people_communications (ppl_id, comm_id, created) 
	VALUES (1, 1, current_timestamp);
SELECT * FROM vets.people_communications;