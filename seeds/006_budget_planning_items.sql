--liquibase formatted sql

--changeset mike:006_budget_planning_items context:dev,test
INSERT INTO planning.budget_items (subcategory_id, description, price, user_id, year)
SELECT
    sub_ids[ceil(random() * array_length(sub_ids, 1))],
    sentence(4),
    (random() * 90000 + 1000)::bigint,
    user_ids[ceil(random() * array_length(user_ids, 1))],
    year()::integer
FROM generate_series(1, ${seedCount} * 5),

LATERAL (
    SELECT array_agg(subcategory_id) AS sub_ids
    FROM dictionary.subcategories
) subcategory,

LATERAL (
    SELECT array_agg(user_id) AS user_ids
    FROM person.users
) users;
--rollback empty