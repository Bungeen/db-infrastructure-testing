--liquibase formatted sql

--changeset mike:010_seed_total_spent context:dev,test
UPDATE person.users u
SET total_spent = sub.total_sum
FROM (
    SELECT user_id, COALESCE(SUM(price), 0) as total_sum
    FROM transaction.expense_transactions
    GROUP BY user_id
) AS sub
WHERE u.user_id = sub.user_id;
--rollback empty