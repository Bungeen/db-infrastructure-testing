-- liquibase formatted sql

-- changeset mike:20260314-005_create_subcategories_table
CREATE TABLE IF NOT EXISTS dictionary.subcategories
(
    subcategory_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    category_id bigint NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT subcategory_pkey PRIMARY KEY (subcategory_id),
    CONSTRAINT fk_category_id FOREIGN KEY (category_id)
        REFERENCES dictionary.categories (category_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);
-- rollback DROP TABLE IF EXISTS dictionary.subcategories;
--end