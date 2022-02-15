-- author: Bruce Goldfeder --
-- date: 14 FEB 2022       -- 
-- project: VETS           --
-- Data Definition Language (DDL) script --

-- Allows creation of functions prior to instantiation of tables or other objects --
SET check_function_bodies = false;

BEGIN;
-- object: vets | type: SCHEMA --
DROP SCHEMA IF EXISTS vets CASCADE;
CREATE SCHEMA vets;

SET search_path TO pg_catalog,vets;

-- Custom Data Types --

DROP TYPE IF EXISTS vets.user_type;
CREATE TYPE vets.user_type AS ENUM
    ('vendor', 'dia government', 'dia seta');
ALTER TYPE vets.user_type
    OWNER TO postgres;

DROP TYPE IF EXISTS vets.comm_types;
CREATE TYPE vets.comm_types AS ENUM
    ('email', 'sms text', 'phone', 'presentation', 'other');
ALTER TYPE vets.comm_types
    OWNER TO postgres;

-- Create Tables for VETS --
DROP TABLE IF EXISTS vets.communications;
CREATE TABLE IF NOT EXISTS vets.communications
(
    communication_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    communicate_type vets.comm_types,
	notes character varying,
    link_url character varying,
	comm_dtg timestamp with time zone,
	created timestamp with time zone,
    CONSTRAINT communications_pkey 
		PRIMARY KEY (communication_id)
);

DROP TABLE IF EXISTS vets.documentation;


DROP TABLE IF EXISTS vets.people;
CREATE TABLE IF NOT EXISTS vets.people
(
    people_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    f_name character varying,
    l_name character varying,
    created timestamp with time zone,
    org_name character varying,
    email character varying,
    phone_num character varying,
    usr_category user_type,
    CONSTRAINT people_pkey 
		PRIMARY KEY (people_id)
);

DROP TABLE IF EXISTS vets.people_communications;
CREATE TABLE IF NOT EXISTS vets.people_communications
(
    ppl_id integer NOT NULL,
    comm_id integer NOT NULL,
    CONSTRAINT people_communications_pkey 
		PRIMARY KEY (ppl_id, comm_id)
);

DROP TABLE IF EXISTS vets.products;
CREATE TABLE IF NOT EXISTS vets.products
(
    product_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	name character varying NOT NULL,
    version character varying,
    price money,
    created timestamp with time zone NOT NULL,
    vnd_id character varying UNIQUE,
    CONSTRAINT products_pkey 
		PRIMARY KEY (product_id)
);

DROP TABLE IF EXISTS vets.products_communications;
CREATE TABLE IF NOT EXISTS vets.products_communications
(
    pdct_id integer NOT NULL,
    comm_id integer NOT NULL,
    CONSTRAINT products_communications_pkey 
		PRIMARY KEY (pdct_id, comm_id)
);

-- Foreign Keys Definitions --

ALTER TABLE vets.people_communications DROP CONSTRAINT IF EXISTS people_communications_communications_comm_id_fkey;
ALTER TABLE IF EXISTS vets.people_communications
    ADD CONSTRAINT people_communications_communications_comm_id_fkey FOREIGN KEY (comm_id)
    REFERENCES vets.communications (communication_id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
    
ALTER TABLE vets.people_communications DROP CONSTRAINT IF EXISTS people_communications_people_id_fkey;
ALTER TABLE IF EXISTS vets.people_communications
    ADD CONSTRAINT people_communications_people_id_fkey FOREIGN KEY (ppl_id)
    REFERENCES vets.people (people_id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
   
ALTER TABLE vets.products_communications DROP CONSTRAINT IF EXISTS products_communications_communications_comm_id_fkey;
ALTER TABLE IF EXISTS vets.products_communications
    ADD CONSTRAINT products_communications_communications_comm_id_fkey FOREIGN KEY (comm_id)
    REFERENCES vets.communications (communication_id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
    
ALTER TABLE vets.products_communications DROP CONSTRAINT IF EXISTS products_communications_products_product_id_fkey;
ALTER TABLE IF EXISTS vets.products_communications
    ADD CONSTRAINT products_communications_products_product_id_fkey FOREIGN KEY (pdct_id)
    REFERENCES vets.products (product_id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;

END;