#Весь код ИИ т.к. это просто эксперименты для просмотра информации

# 1) Посмотреть на невидимые колонки
CREATE TABLE mvcc_test (id SERIAL PRIMARY KEY, value TEXT);
INSERT INTO mvcc_test (value) VALUES ('original');

SELECT id, value, xmin, xmax, ctid FROM mvcc_test;
#виден xmin (ID создавшей транзакции), xmax = 0, ctid указывает на физическое место.
  
# 2) Обновление строки — создание новой версии
SELECT id, value, xmin, xmax, ctid FROM mvcc_test;
UPDATE mvcc_test SET value = 'updated' WHERE id = 1;
SELECT id, value, xmin, xmax, ctid FROM mvcc_test;
#появилась новая версия с новым xmin и новым ctid. Старая версия осталась на диске, но скрыта.
  
# 3) Удаление строки — тоже версия
DELETE FROM mvcc_test WHERE id = 1;
SELECT id, value, xmin, xmax, ctid FROM mvcc_test; 
# Физически строка всё ещё есть на диске, но xmax помечен. PostgreSQL не показывает её.
  
# 4) Мёртвые строки и VACUUM
-- Вставляем 3000 строк
INSERT INTO mvcc_test (value) SELECT 'row_' || generate_series(1, 3000);

-- Делаем 5 обновлений всей таблицы
UPDATE mvcc_test SET value = 'v1';
UPDATE mvcc_test SET value = 'v2';
UPDATE mvcc_test SET value = 'v3';
UPDATE mvcc_test SET value = 'v4';
UPDATE mvcc_test SET value = 'v5';

-- Смотрим статистику
SELECT relname, n_live_tup, n_dead_tup 
FROM pg_stat_user_tables 
WHERE relname = 'mvcc_test';

-- Запускаем VACUUM
VACUUM VERBOSE mvcc_test;

-- Статистика после VACUUM
SELECT relname, n_live_tup, n_dead_tup 
FROM pg_stat_user_tables 
WHERE relname = 'mvcc_test';

#PostgreSQL не хранит все промежуточные версии строк. После каждого обновления остаётся только одна мёртвая версия (предыдущая). VACUUM удаляет мёртвые строки и обновляет статистику. ANALYZE обновляет статистику для планировщика, но не очищает мёртвые строки.

# 5) Почему COUNT(*) медленный на больших таблицах

-- Создаём таблицу
DROP TABLE IF EXISTS big_table;
CREATE TABLE big_table (id SERIAL, data TEXT);
INSERT INTO big_table (data) SELECT 'row_' || generate_series(1, 100000);

-- Обновляем 5 раз для создания мёртвых строк
UPDATE big_table SET data = 'v1';
UPDATE big_table SET data = 'v2';
UPDATE big_table SET data = 'v3';
UPDATE big_table SET data = 'v4';
UPDATE big_table SET data = 'v5';

-- Замер времени
\timing
SELECT COUNT(*) FROM big_table;
VACUUM big_table;
SELECT COUNT(*) FROM big_table;

#VACUUM ускоряет COUNT(*), потому что удаляет мёртвые строки и уплотняет живые строки на страницах. На маленьких таблицах (до 100 МБ) разница может быть незаметной из-за кэширования. На больших таблицах (гигабайты) разница может быть драматичной (минуты против секунд).
