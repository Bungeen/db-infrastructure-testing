-- liquibase formatted sql

-- changeset mike:20260314-007_receipt_files_links_tables
CREATE SCHEMA IF NOT EXISTS transaction;

CREATE TABLE IF NOT EXISTS transaction.receipt_files
(
    receipt_file_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    raw_file bytea NOT NULL,
    CONSTRAINT receipt_file_pkey PRIMARY KEY (receipt_file_id)
);

CREATE TABLE IF NOT EXISTS transaction.receipt_links
(
    receipt_link_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    url text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT receipt_link_pkey PRIMARY KEY (receipt_link_id)
);
-- rollback DROP TABLE IF EXISTS transaction.receipt_files; DROP TABLE IF EXISTS transaction.receipt_links; DROP SCHEMA IF EXISTS transaction;
--end