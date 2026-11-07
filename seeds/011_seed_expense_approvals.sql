--liquibase formatted sql

--changeset mike:011_seed_expense_approvals context:dev,test
INSERT INTO transaction.expense_approvals (
    expense_transaction_id,
    approver_user_id,
    status,
    comment,
    created_at
)
SELECT 
    et.expense_transaction_id,
    (floor(random() * 10) + 1)::bigint AS approver_user_id,
    
    CASE 
        WHEN random() < 0.8 THEN 'Approved'::transaction.approval_status
        WHEN random() < 0.9 THEN 'Rejected'::transaction.approval_status
        ELSE 'Pending'::transaction.approval_status
    END AS status,
    
    sentence(4) AS comment,
    et.date + interval '1 hour' AS created_at
FROM transaction.expense_transactions et;
--rollback empty