--liquibase formatted sql

--changeset mike:007_seed_files_links context:dev,test
INSERT INTO transaction.receipt_links (url)
SELECT
    url() || md5(random()::text) || '.pdf'
FROM generate_series(1, ${seedCount} * 5);

INSERT INTO transaction.receipt_files (raw_file)
SELECT
    decode(md5(random()::text), 'hex')
FROM generate_series(1, ${seedCount} * 5)
--rollback empty