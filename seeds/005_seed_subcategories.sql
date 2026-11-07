--liquibase formatted sql

--changeset mike:005_seed_subcategories context:dev,test
INSERT INTO dictionary.subcategories (category_id, name, description)
SELECT
    c.category_id,
    word() || ' ' || word(),
    paragraph()
FROM dictionary.categories c
JOIN generate_series(1, 5) g(i) ON TRUE
WHERE random() < 0.6;
--rollback empty