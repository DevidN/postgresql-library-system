#Для начала создаем таблицу на 10000 строк(в маленькой таблице sql не будет искать по индексу), код по рандомной таблице взял в гугле
CREATE TABLE test_data AS
SELECT
    id,
    'User_' || id AS username,
    md5(random()::text) AS random_hash, -- Случайная строка
    (random() * 1000)::integer AS score, -- Случайное число 0-1000
    now() - (random() * interval '365 days') AS created_at -- Случайная дата за год
FROM generate_series(1, 10000) AS id;

#Проверя сколько времени займет поиск без индекса
EXPLAIN ANALYZE SELECT * FROM test_data WHERE score = 816;

# 1.221 ms без индекса
 Seq Scan on test_data  (cost=0.00..239.00 rows=16 width=58) (actual time=0.058..1.203 rows=16.00 loops=1)
   Filter: (score = 816)
   Rows Removed by Filter: 9984
   Buffers: shared hit=114
 Planning:
   Buffers: shared hit=20
 Planning Time: 1.158 ms
 Execution Time: 1.221 ms
(8 строк)

# Создаем индекс и проверяем, результат 0.228 ms с индексом
CREATE INDEX idx_score ON test_data (score);
EXPLAIN ANALYZE SELECT * FROM test_data WHERE score = 816;

 Bitmap Heap Scan on test_data  (cost=4.41..48.29 rows=16 width=58) (actual time=0.140..0.155 rows=16.00 loops=1)
   Recheck Cond: (score = 816)
   Heap Blocks: exact=14
   Buffers: shared hit=14 read=2
   ->  Bitmap Index Scan on idx_score  (cost=0.00..4.41 rows=16 width=0) (actual time=0.115..0.115 rows=16.00 loops=1)
         Index Cond: (score = 816)
         Index Searches: 1
         Buffers: shared read=2
 Planning:
   Buffers: shared hit=15 read=1
 Planning Time: 1.589 ms
 Execution Time: 0.228 ms
(12 строк)
