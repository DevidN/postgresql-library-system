DROP TABLE IF EXISTS test_isolation;
CREATE TABLE test_isolation (
    id SERIAL PRIMARY KEY,
    value INTEGER
);

INSERT INTO test_isolation (value) VALUES (1), (2), (3);

# 1) Грязное чтение (dirty read) Проверяем: может ли одна транзакция увидеть незакоммиченные изменения другой транзакции?

#Консоль А
BEGIN;
UPDATE test_isolation SET value = 999 WHERE id = 1;

#Консоль Б
SELECT * FROM test_isolation WHERE id = 1;
#Консоль Б видит 1, а не 999. В PostgreSQL грязное чтение невозможно. Уровень READ COMMITTED (используемый по умолчанию) защищает от него.

# 2) Фантомное чтение (phantom read) Проверяем: может ли транзакция увидеть новые строки, добавленные другой транзакцией.

#Консоль А
BEGIN;
SELECT COUNT(*) FROM test_isolation;

#Консоль Б
INSERT INTO test_isolation (value) VALUES (4);
COMMIT;

#Консоль А
SELECT COUNT(*) FROM test_isolation;   -- результат: 4
COMMIT;
#Количество строк внутри транзакции А изменилось с 3 до 4. Фантомное чтение возможно на уровне READ COMMITTED. 

# 3) Неповторяющееся чтение (non-repeatable read). Проверяем: может ли транзакция увидеть разные значения при повторном SELECT, если другая транзакция изменила данные и закоммитила?
 
#Консоль А   
BEGIN;
SELECT * FROM test_isolation WHERE id = 1;   -- видит 1

#Консоль Б
UPDATE test_isolation SET value = 888 WHERE id = 1;
COMMIT;

#Консоль А
SELECT * FROM test_isolation WHERE id = 1;   -- видит 888
COMMIT;
#Внутри одной транзакции (А) значение изменилось с 1 на 888. На уровне READ COMMITTED возможно неповторяющееся чтение. 
    
# 4) REPEATABLE READ — защита от неповторяющегося чтения. Проверяем: будет ли повторный SELECT видеть изменения, сделанные и закоммиченные другой транзакцией.

#Консоль А
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM test_isolation WHERE id = 1;

#Консоль Б
UPDATE test_isolation SET value = 777 WHERE id = 1;
COMMIT;

#Консоль А
SELECT * FROM test_isolation WHERE id = 1;
COMMIT;

#Даже после того, как консоль Б закоммитила изменение, консоль А продолжает видеть старое значение. Уровень REPEATABLE READ даёт снимок данных на момент начала транзакции и защищает от неповторяющегося чтения.

# 5) Аномалия сериализации (SERIALIZABLE). Проверяем: что произойдёт, если две транзакции на уровне SERIALIZABLE одновременно попытаются вставить строку, которая на момент чтения отсутствует.

DELETE FROM test_isolation WHERE value = 4;
SELECT * FROM test_isolation;   -- только 1,2,3

#Консоль А
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM test_isolation WHERE value = 4;   -- пусто

#Консоль Б
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM test_isolation WHERE value = 4;   -- пусто

#Консоль А
INSERT INTO test_isolation (value) VALUES (4);
COMMIT;   -- успешно

#Консоль Б
INSERT INTO test_isolation (value) VALUES (4);
COMMIT;   -- ОШИБКА

# Уровень SERIALIZABLE не позволяет получить результат, который невозможен при последовательном выполнении транзакций. Одна из конфликтующих транзакций отменяется с ошибкой сериализации.
