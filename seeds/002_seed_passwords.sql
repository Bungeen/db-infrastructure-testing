--liquibase formatted sql

--changeset mike:002_seed_passwords context:dev,test
INSERT INTO person.passwords (password_hash)
SELECT
    md5(random()::text)
FROM generate_series(1, ${SeedCount} * 20);
--rollback empty