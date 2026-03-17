--liquibase formatted sql

--changeset mike:008_income_transactions context:dev,test
INSERT INTO dictionary.income_transaction_types (name, description)
SELECT
    word() || ' ' || word(),
    paragraph()
FROM generate_series(1, ${seedCount});

INSERT INTO transaction.income_transactions
(
    price,
    date,
    user_id,
    description,
    income_transaction_type_id,
    category_id
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

    cat_ids[ceil(random() * array_length(cat_ids, 1))]

FROM generate_series(1, ${seedCount} * 30),

LATERAL (
    SELECT array_agg(user_id) AS user_ids FROM person.users
) u,

LATERAL (
    SELECT array_agg(income_transaction_type_id) AS type_ids
    FROM dictionary.income_transaction_types
) t,

LATERAL (
    SELECT array_agg(category_id) AS cat_ids
    FROM dictionary.categories
) c;

INSERT INTO transaction.income_links
(income_transaction_id, receipt_link_id)
SELECT
    it.income_transaction_id,
    rl.receipt_link_id
FROM transaction.income_transactions it
JOIN transaction.receipt_links rl ON TRUE
WHERE random() < 0.05;

INSERT INTO transaction.income_files
(receipt_file_id, income_transaction_id)
SELECT
    rf.receipt_file_id,
    it.income_transaction_id
FROM transaction.income_transactions it
JOIN transaction.receipt_files rf ON TRUE
WHERE random() < 0.05;
--rollback empty