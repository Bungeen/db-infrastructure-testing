--liquibase formatted sql

--changeset mike:004_seed_categories context:dev,test
INSERT INTO dictionary.categories (name, description)
SELECT
    word(),
    sentence(4)
FROM generate_series(1, ${seedCount})
--rollback empty