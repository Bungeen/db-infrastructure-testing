--liquibase formatted sql

--changeset mike:009_expense_transactions context:dev,test
INSERT INTO dictionary.expense_transaction_types (name, description)
SELECT
    word() || ' ' || word(),
    paragraph()
FROM generate_series(1, ${seedCount});

INSERT INTO transaction.expense_transactions
(
    price,
    date,
    user_id,
    description,
    expense_transaction_type_id,
    subcategory_id
)
SELECT
    round(
        CASE
            WHEN random() < 0.7 THEN random() * 5000 + 1000
            ELSE random() * 40000 + 5000
        END
    )::bigint,

    NOW() - (random() * interval '365 days'),

    user_ids[ceil(random() * array_length(user_ids, 1))],

    sentence(5),

    type_ids[ceil(random() * array_length(type_ids, 1))],

    sub_ids[ceil(random() * array_length(sub_ids, 1))]

FROM generate_series(1, ${seedCount} * 30),

LATERAL (
    SELECT array_agg(user_id) AS user_ids FROM person.users
) u,

LATERAL (
    SELECT array_agg(expense_transaction_type_id) AS type_ids
    FROM dictionary.expense_transaction_types
) t,

LATERAL (
    SELECT array_agg(subcategory_id) AS sub_ids
    FROM dictionary.subcategories
) s;

INSERT INTO transaction.expense_links
(expense_transaction_id, receipt_link_id)
SELECT
    et.expense_transaction_id,
    rl.receipt_link_id
FROM transaction.expense_transactions et
JOIN transaction.receipt_links rl ON TRUE
WHERE random() < 0.05;

INSERT INTO transaction.expense_files
(receipt_file_id, expense_transaction_id)
SELECT
    rf.receipt_file_id,
    et.expense_transaction_id
FROM transaction.expense_transactions et
JOIN transaction.receipt_files rf ON TRUE
WHERE random() < 0.05;
--rollback empty