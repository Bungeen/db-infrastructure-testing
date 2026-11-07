--liquibase formatted sql

--changeset mike:003_seed_users context:dev,test
INSERT INTO person.users
(
    login,
    personality_id,
    password_id,
    description,
    role,
    email
)
SELECT
    user_name(),
    ((row_number() OVER () - 1) % (SELECT count(*) FROM person.personalities) + 1)::bigint,
    ((row_number() OVER () - 1) % (SELECT count(*) FROM person.passwords) + 1)::bigint,
    paragraph(),
    (ARRAY['Spectator','Trustee','Admin'])[floor(random()*3)+1]::person.role,
    email()
FROM person.personalities p
CROSS JOIN person.passwords pw
LIMIT ${seedCount};
--rollback empty