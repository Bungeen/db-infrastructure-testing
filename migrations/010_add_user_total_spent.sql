-- liquibase formatted sql

-- changeset mike:20260504-010_add_user_total_spent
ALTER TABLE person.users 
ADD COLUMN IF NOT EXISTS total_spent BIGINT DEFAULT 0;

UPDATE person.users SET total_spent = 0 WHERE total_spent IS NULL;
-- rollback ALTER TABLE person.users DROP COLUMN IF EXISTS total_spent;
-- end