-- liquibase formatted sql

-- changeset mike:20260504-014_add_category_stats
CREATE SCHEMA IF NOT EXISTS analytics;

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.category_stats AS
SELECT 
    c.name AS category_name, 
    SUM(et.price) AS total_sum,
    COUNT(*) AS count_transactions
FROM transaction.expense_transactions et
JOIN dictionary.subcategories sc ON et.subcategory_id = sc.subcategory_id
JOIN dictionary.categories c ON sc.category_id = c.category_id
JOIN transaction.expense_approvals ea ON et.expense_transaction_id = ea.expense_transaction_id
WHERE et.date > NOW() - INTERVAL '1 year'
    AND ea.status = 'Approved'
GROUP BY c.name;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_category_name ON analytics.category_stats(category_name);
-- rollback 
-- DROP INDEX IF EXISTS analytics.idx_mv_category_name;
-- DROP MATERIALIZED VIEW IF EXISTS analytics.category_stats;
-- DROP SCHEMA IF EXISTS person CASCADE;
-- end