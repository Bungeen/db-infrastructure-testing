-- liquibase formatted sql

-- changeset mike:20260504-012_add_btree_hash_indexes
CREATE INDEX IF NOT EXISTS idx_approvals_expense_status_btree 
ON transaction.expense_approvals USING BTREE (expense_transaction_id, status);

CREATE INDEX IF NOT EXISTS idx_income_date_btree 
ON transaction.income_transactions USING BTREE (date);

CREATE INDEX IF NOT EXISTS idx_expense_subcategory_hash 
ON transaction.expense_transactions USING HASH (subcategory_id);
-- rollback 
-- DROP INDEX IF EXISTS transaction.idx_approvals_expense_status_btree;
-- DROP INDEX IF EXISTS transaction.idx_income_date_btree;
-- DROP INDEX IF EXISTS transaction.idx_expense_subcategory_hash;
-- end