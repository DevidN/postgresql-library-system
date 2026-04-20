#Вывести всю иерархию подчинённых для директора (id = 1), включая уровень вложенности.

DROP TABLE IF EXISTS employees_hierarchy;
CREATE TABLE employees_hierarchy (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    manager_id INTEGER REFERENCES employees_hierarchy(id)
);

INSERT INTO employees_hierarchy (name, manager_id) VALUES
    ('Директор', NULL),
    ('Нач. отдела', 1),
    ('Старший менеджер', 2),
    ('Менеджер', 3),
    ('Стажёр', 4);


WITH RECURSIVE hierarchy_subordinates AS(
SELECT id, name, manager_id, 1 AS level
FROM employees_hierarchy
WHERE id = 1

UNION ALL

SELECT e.id, e.name, e.manager_id, h.level + 1
FROM employees_hierarchy e
INNER JOIN hierarchy_subordinates h ON e.manager_id = h.id
)

SELECT * FROM hierarchy_subordinates
