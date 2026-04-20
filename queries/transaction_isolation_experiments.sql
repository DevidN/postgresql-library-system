DROP TABLE IF EXISTS test_isolation;
CREATE TABLE test_isolation (
    id SERIAL PRIMARY KEY,
    value INTEGER
);

INSERT INTO test_isolation (value) VALUES (1), (2), (3);

#dirty read
#в разных консолях
SELECT * FROM test_isolation;

#Консоль 1 без COMMIT
BEGIN;
UPDATE test_isolation SET value = 999 WHERE id = 1;

#Консоль 2 нет изменений Dirty read в PostgreSQL невозможен в принципе
SELECT * FROM test_isolation;


#Неповторяющееся чтение (non-repeatable read)

BEGIN;
SELECT * FROM test_isolation WHERE id = 1;   -- увидишь старое значение

UPDATE test_isolation SET value = 888 WHERE id = 1;
COMMIT;

SELECT * FROM test_isolation WHERE id = 1;   -- увидишь новое значение 888

# Фантомное чтение (phantom read)

BEGIN;
SELECT COUNT(*) FROM test_isolation;   -- например, 3

INSERT INTO test_isolation (value) VALUES (4);
COMMIT;

#REPEATABLE READ — защита от non-repeatable read

# A
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM test_isolation WHERE id = 1;

-- 1. Б
UPDATE test_isolation SET value = 777 WHERE id = 1;
COMMIT;


# A
SELECT * FROM test_isolation WHERE id = 1;   -- всё ещё 1 (старое значение!)

-- 3. Завершить транзакцию
COMMIT;

-- 4. Посмотреть после завершения
SELECT * FROM test_isolation WHERE id = 1;   -- теперь 777

# Эксперимент 5. Аномалия сериализации (serialization anomaly)
