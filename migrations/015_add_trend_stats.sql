-- liquibase formatted sql

-- changeset mike:20260504-015_add_trend_stats
CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.monthly_income_trend AS
SELECT 
    date_trunc('month', date) AS month_start,
    SUM(price) AS total_sum,
    COUNT(*) AS count_transactions
FROM transaction.income_transactions
GROUP BY 1
ORDER BY 1;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_month_start ON analytics.monthly_income_trend(month_start);
-- rollback 
-- DROP INDEX IF EXISTS analytics.idx_mv_month_start;
-- DROP MATERIALIZED VIEW IF EXISTS analytics.monthly_income_trend;
-- end