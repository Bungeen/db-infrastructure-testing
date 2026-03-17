-- liquibase formatted sql

-- changeset mike:20260314-003_create_users_table
CREATE TYPE person.role AS ENUM
    ('Spectator', 'Trustee', 'Admin');

CREATE TABLE IF NOT EXISTS person.users
(
    user_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    login text COLLATE pg_catalog."default" NOT NULL,
    personality_id bigint,
    password_id bigint NOT NULL,
    description text COLLATE pg_catalog."default",
    role person.role NOT NULL,
    email text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT user_data_pkey PRIMARY KEY (user_id),
    CONSTRAINT fk_password_id FOREIGN KEY (password_id)
        REFERENCES person.passwords (password_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_personality_id FOREIGN KEY (personality_id)
        REFERENCES person.personalities (personality_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);
-- rollback DROP TABLE IF EXISTS person.users; DROP TYPE IF EXISTS person.role;
--end