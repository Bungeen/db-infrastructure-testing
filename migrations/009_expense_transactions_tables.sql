-- liquibase formatted sql

-- changeset mike:20260314-009_expense_transactions_tables
CREATE TABLE IF NOT EXISTS dictionary.expense_transaction_types
(
    expense_transaction_type_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT expense_transaction_type_pkey PRIMARY KEY (expense_transaction_type_id)
);

CREATE TABLE IF NOT EXISTS transaction.expense_transactions
(
    expense_transaction_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    price bigint NOT NULL,
    date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_id bigint NOT NULL,
    description text COLLATE pg_catalog."default",
    modified_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expense_transaction_type_id bigint NOT NULL,
    subcategory_id bigint NOT NULL,
    CONSTRAINT expense_transaction_pkey PRIMARY KEY (expense_transaction_id),
    CONSTRAINT fk_expense_transaction_type_id FOREIGN KEY (expense_transaction_type_id)
        REFERENCES dictionary.expense_transaction_types (expense_transaction_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_subcategory_id FOREIGN KEY (subcategory_id)
        REFERENCES dictionary.subcategories (subcategory_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id)
        REFERENCES person.users (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS transaction.expense_links
(
    expense_transaction_id bigint NOT NULL,
    receipt_link_id bigint NOT NULL,
    CONSTRAINT expense_links_pkey PRIMARY KEY (expense_transaction_id, receipt_link_id),
    CONSTRAINT fk_expense_transaction_id FOREIGN KEY (expense_transaction_id)
        REFERENCES transaction.expense_transactions (expense_transaction_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_receipt_link_id FOREIGN KEY (receipt_link_id)
        REFERENCES transaction.receipt_links (receipt_link_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS transaction.expense_files
(
    receipt_file_id bigint NOT NULL,
    expense_transaction_id bigint NOT NULL,
    CONSTRAINT expense_files_pkey PRIMARY KEY (receipt_file_id, expense_transaction_id),
    CONSTRAINT fk_expense_transaction_id FOREIGN KEY (expense_transaction_id)
        REFERENCES transaction.expense_transactions (expense_transaction_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_receipt_file_id FOREIGN KEY (receipt_file_id)
        REFERENCES transaction.receipt_files (receipt_file_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
--rollback DROP TABLE IF EXISTS transaction.expense_files CASCADE;
--rollback DROP TABLE IF EXISTS transaction.expense_links CASCADE;
--rollback DROP TABLE IF EXISTS transaction.expense_transactions CASCADE;
--rollback DROP TABLE IF EXISTS dictionary.expense_transaction_types CASCADE;
--end