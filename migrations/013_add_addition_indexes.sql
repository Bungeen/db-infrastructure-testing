-- liquibase formatted sql

-- changeset mike:20260504-013_add_addition_indexes
CREATE INDEX IF NOT EXISTS idx_expense_date_btree 
ON transaction.expense_transactions USING BTREE (date);

CREATE INDEX IF NOT EXISTS idx_budget_user_id_btree 
ON planning.budget_items USING BTREE (user_id);
-- rollback 
-- DROP INDEX IF EXISTS transaction.idx_expense_date_btree;
-- DROP INDEX IF EXISTS planning.idx_budget_user_id_btree;
-- end