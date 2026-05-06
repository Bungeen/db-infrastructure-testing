-- liquibase formatted sql

-- changeset mike:20260504-011_add_expense_approvals
CREATE TYPE transaction.approval_status AS ENUM
    ('Pending', 'Approved', 'Rejected');

CREATE TABLE IF NOT EXISTS transaction.expense_approvals
(
    approval_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    expense_transaction_id bigint NOT NULL,
    approver_user_id bigint NOT NULL,
    status transaction.approval_status NOT NULL DEFAULT 'Pending'::transaction.approval_status,
    comment text COLLATE pg_catalog."default",
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT expense_approvals_pkey PRIMARY KEY (approval_id),
    CONSTRAINT fk_expense_transaction_id FOREIGN KEY (expense_transaction_id)
        REFERENCES transaction.expense_transactions (expense_transaction_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT fk_approver_user_id FOREIGN KEY (approver_user_id)
        REFERENCES person.users (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);
-- rollback DROP TABLE IF EXISTS transaction.expense_approvals; DROP TYPE IF EXISTS transaction.approval_status;
-- end