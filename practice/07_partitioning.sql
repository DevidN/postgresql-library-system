DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id SERIAL,
    order_date DATE NOT NULL,
    amount NUMERIC,
    customer_id INTEGER
) PARTITION BY RANGE (order_date);


#1 Создать партиции по месяцам
CREATE TABLE orders_2024_01 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE orders_2024_02 PARTITION OF orders
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE orders_2024_03 PARTITION OF orders
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

#2 Вставить заказы с разными датами (январь, февраль, март 2024). Проверить:в какую партицию попал каждый заказ?
INSERT INTO orders (order_date, amount, customer_id) VALUES
    ('2024-01-15', 100, 1),
    ('2024-02-10', 200, 2),
    ('2024-03-05', 150, 3);

SELECT id,
    order_date,
    tableoid::regclass AS partition_name
FROM orders;

#3 Посмотреть план запроса с партиционированием
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date BETWEEN '2024-02-01' AND '2024-02-28';
# Partition Pruning (обрезание партиций). Планировщик понял, что данные за февраль могут быть только в одной партиции, и остальные даже не открывал.

#4 Создать партицию DEFAULT
CREATE TABLE orders_other PARTITION OF orders DEFAULT;

#5 Вставить заказ с датой 2024-05-01 (май, для которого нет отдельной партиции)
INSERT INTO orders (order_date, amount, customer_id) VALUES ('2024-05-01', 500, 99);
SELECT id, order_date, tableoid::regclass AS partition_name FROM orders WHERE order_date = '2024-05-01';

#6 Сравнить производительность
CREATE TABLE orders_normal AS SELECT * FROM orders;

EXPLAIN ANALYZE SELECT * FROM orders WHERE order_date BETWEEN '2024-02-01' AND '2024-02-28';
EXPLAIN ANALYZE SELECT * FROM orders_normal WHERE order_date BETWEEN '2024-02-01' AND '2024-02-28';
#Select с partition обработался быстрее , чем со всей таблицей
