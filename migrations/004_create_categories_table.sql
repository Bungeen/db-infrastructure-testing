-- liquibase formatted sql

-- changeset mike:20260314-004_create_categories_table
CREATE SCHEMA IF NOT EXISTS dictionary;

CREATE TABLE IF NOT EXISTS dictionary.categories
(
    category_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT category_pkey PRIMARY KEY (category_id)
);
-- rollback DROP TABLE IF EXISTS dictionary.categories; DROP SCHEMA IF EXISTS dictionary;
--end