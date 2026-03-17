--liquibase formatted sql

--changeset mike:001_seed-personalities context:dev,test
CREATE EXTENSION IF NOT EXISTS plpython3u;
CREATE EXTENSION IF NOT EXISTS faker;

INSERT INTO person.personalities
(first_name, middle_name, last_name, sex)
SELECT
    first_name(),
    first_name(),
    last_name(),
    CASE
        WHEN random() < 0.49 THEN 'male'::person.gender
        WHEN random() < 0.98 THEN 'female'::person.gender
        ELSE 'other'::person.gender
    END
FROM generate_series(1, ${SeedCount} * 20);
--rollback empty