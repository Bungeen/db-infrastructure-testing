-- liquibase formatted sql

-- changeset mike:20260314-002_create_passwords_table


CREATE TABLE IF NOT EXISTS person.passwords
(
    password_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    password_hash character varying(255) NOT NULL,
    CONSTRAINT password_pkey PRIMARY KEY (password_id)
);
-- rollback DROP TABLE IF EXISTS person.passwords;
--end