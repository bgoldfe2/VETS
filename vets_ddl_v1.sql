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

SET search_path TO pg_catalog,public,vets;

DROP TABLE IF EXISTS vets.communications;
CREATE TABLE IF NOT EXISTS vets.communications
(
    comm_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    created timestamp with time zone,
    prod_id integer,
    communicate_type comm_types,
    person_id character varying COLLATE pg_catalog."default",
    CONSTRAINT communications_pkey PRIMARY KEY (comm_id)
);

DROP TABLE IF EXISTS vets.documentation;
CREATE TABLE IF NOT EXISTS vets.documentation
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    notes character varying COLLATE pg_catalog."default",
    mtg_id integer,
    comm_ref integer,
    CONSTRAINT documentation_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS vets.people;
CREATE TABLE IF NOT EXISTS vets.people
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    f_name character varying COLLATE pg_catalog."default",
    l_name character varying COLLATE pg_catalog."default",
    created timestamp with time zone,
    org_name character varying COLLATE pg_catalog."default",
    email character varying COLLATE pg_catalog."default",
    phone_num character varying COLLATE pg_catalog."default",
    usr_category user_type,
    CONSTRAINT people_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS vets.people_communications;
CREATE TABLE IF NOT EXISTS vets.people_communications
(
    people_id integer NOT NULL,
    communications_comm_id integer NOT NULL,
    CONSTRAINT people_communications_pkey PRIMARY KEY (people_id, communications_comm_id)
);

DROP TABLE IF EXISTS vets.products;
CREATE TABLE IF NOT EXISTS vets.products
(
    name character varying COLLATE pg_catalog."default" NOT NULL,
    version character varying COLLATE pg_catalog."default" NOT NULL,
    price money,
    created timestamp with time zone NOT NULL,
    product_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    vnd_id character varying COLLATE pg_catalog."default" UNIQUE,
    CONSTRAINT products_pkey PRIMARY KEY (product_id)
);

DROP TABLE IF EXISTS vets.products_communications;
CREATE TABLE IF NOT EXISTS vets.products_communications
(
    products_product_id integer NOT NULL,
    communications_comm_id integer NOT NULL,
    CONSTRAINT products_communications_pkey PRIMARY KEY (products_product_id, communications_comm_id)
);

-- Foreign Keys for XRef Tables --

ALTER TABLE vets.documentation DROP CONSTRAINT IF EXISTS documentation_comm_ref_fkey;
ALTER TABLE IF EXISTS vets.documentation
    ADD CONSTRAINT documentation_comm_ref_fkey FOREIGN KEY (comm_ref)
    REFERENCES public.communications (comm_id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
    
ALTER TABLE vets.people_communications DROP CONSTRAINT IF EXISTS people_communications_communications_comm_id_fkey;
ALTER TABLE IF EXISTS vets.people_communications
    ADD CONSTRAINT people_communications_communications_comm_id_fkey FOREIGN KEY (communications_comm_id)
    REFERENCES public.communications (comm_id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
    
ALTER TABLE vets.people_communications DROP CONSTRAINT IF EXISTS people_communications_people_id_fkey;
ALTER TABLE IF EXISTS vets.people_communications
    ADD CONSTRAINT people_communications_people_id_fkey FOREIGN KEY (people_id)
    REFERENCES public.people (id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
   
ALTER TABLE vets.products_communications DROP CONSTRAINT IF EXISTS products_communications_communications_comm_id_fkey;
ALTER TABLE IF EXISTS vets.products_communications
    ADD CONSTRAINT products_communications_communications_comm_id_fkey FOREIGN KEY (communications_comm_id)
    REFERENCES public.communications (comm_id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
    
ALTER TABLE vets.products_communications DROP CONSTRAINT IF EXISTS products_communications_products_product_id_fkey;
ALTER TABLE IF EXISTS vets.products_communications
    ADD CONSTRAINT products_communications_products_product_id_fkey FOREIGN KEY (products_product_id)
    REFERENCES public.products (product_id) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;

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


END;