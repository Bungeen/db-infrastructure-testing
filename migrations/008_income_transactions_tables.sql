-- liquibase formatted sql

-- changeset mike:20260314-008_income_transactions_tables
CREATE TABLE IF NOT EXISTS dictionary.income_transaction_types
(
    income_transaction_type_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT income_transaction_type_pkey PRIMARY KEY (income_transaction_type_id)
);

CREATE TABLE IF NOT EXISTS transaction.income_transactions
(
    income_transaction_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    price bigint NOT NULL,
    date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_id bigint NOT NULL,
    description text COLLATE pg_catalog."default",
    modified_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    income_transaction_type_id bigint NOT NULL,
    category_id bigint NOT NULL,
    CONSTRAINT income_transaction_pkey PRIMARY KEY (income_transaction_id),
    CONSTRAINT fk_category_id FOREIGN KEY (category_id)
        REFERENCES dictionary.categories (category_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_income_transaction_type_id FOREIGN KEY (income_transaction_type_id)
        REFERENCES dictionary.income_transaction_types (income_transaction_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id)
        REFERENCES person.users (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS transaction.income_links
(
    income_transaction_id bigint NOT NULL,
    receipt_link_id bigint NOT NULL,
    CONSTRAINT income_links_pkey PRIMARY KEY (income_transaction_id, receipt_link_id),
    CONSTRAINT fk_income_transaction_id FOREIGN KEY (income_transaction_id)
        REFERENCES transaction.income_transactions (income_transaction_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_receipt_link_id FOREIGN KEY (receipt_link_id)
        REFERENCES transaction.receipt_links (receipt_link_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS transaction.income_files
(
    receipt_file_id bigint NOT NULL,
    income_transaction_id bigint NOT NULL,
    CONSTRAINT income_files_pkey PRIMARY KEY (receipt_file_id, income_transaction_id),
    CONSTRAINT fk_income_transaction_id FOREIGN KEY (income_transaction_id)
        REFERENCES transaction.income_transactions (income_transaction_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_receipt_file_id FOREIGN KEY (receipt_file_id)
        REFERENCES transaction.receipt_files (receipt_file_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- rollback DROP TABLE IF EXISTS transaction.income_links; DROP TABLE IF EXISTS transaction.income_files; DROP TABLE IF EXISTS transaction.income_transactions; DROP TABLE IF EXISTS dictionary.income_transaction_types;
--end