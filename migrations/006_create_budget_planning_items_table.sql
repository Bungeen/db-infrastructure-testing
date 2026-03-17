-- liquibase formatted sql

-- changeset mike:20260314-006_create_budget_planning_items_table
CREATE SCHEMA IF NOT EXISTS planning;

CREATE TABLE IF NOT EXISTS planning.budget_items
(
    budget_item_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    subcategory_id bigint NOT NULL,
    description text COLLATE pg_catalog."default",
    price bigint NOT NULL,
    user_id bigint NOT NULL,
    modified_date timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    year integer NOT NULL,
    CONSTRAINT budget_items_pkey PRIMARY KEY (budget_item_id),
    CONSTRAINT fk_subcategory_id FOREIGN KEY (subcategory_id)
        REFERENCES dictionary.subcategories (subcategory_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id)
        REFERENCES person.users (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- rollback DROP TABLE IF EXISTS planning.budget_items; DROP SCHEMA IF EXISTS planning;
--end