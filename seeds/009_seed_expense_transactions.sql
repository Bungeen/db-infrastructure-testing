--liquibase formatted sql

--changeset mike:009_seed_expense_transactions context:dev,test
INSERT INTO dictionary.expense_transaction_types (name, description)
SELECT
    word() || ' ' || word(),
    paragraph()
FROM generate_series(1, 100);

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
    r.arr[floor(random() * array_length(r.arr, 1)) + 1]
FROM transaction.expense_transactions et
CROSS JOIN (
    SELECT array_agg(receipt_link_id) AS arr
    FROM transaction.receipt_links
) r
WHERE random() < 0.05;

INSERT INTO transaction.expense_files
(receipt_file_id, expense_transaction_id)
SELECT
    f.arr[floor(random() * array_length(f.arr, 1)) + 1],
    et.expense_transaction_id
FROM transaction.expense_transactions et
CROSS JOIN (
    SELECT array_agg(receipt_file_id) AS arr
    FROM transaction.receipt_files
) f
WHERE random() < 0.05;
--rollback empty