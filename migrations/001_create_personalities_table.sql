-- liquibase formatted sql

-- changeset mike:20260314-001_create_personalities_table
CREATE SCHEMA IF NOT EXISTS person;

CREATE TYPE person.gender AS ENUM
    ('male', 'female', 'other');

CREATE TABLE IF NOT EXISTS person.personalities
(
    personality_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    first_name text COLLATE pg_catalog."default" NOT NULL,
    middle_name text COLLATE pg_catalog."default",
    last_name text COLLATE pg_catalog."default",
    modified_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sex person.gender NOT NULL,
    CONSTRAINT personality_pkey PRIMARY KEY (personality_id)
);
-- rollback DROP TABLE IF EXISTS person.personalities; DROP TYPE IF EXISTS person.gender;  DROP SCHEMA IF EXISTS person CASCADE;
--end