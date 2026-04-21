DROP TABLE IF EXISTS articles;
CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    title TEXT,
    content TEXT
);

INSERT INTO articles (title, content) VALUES
    ('PostgreSQL уроки', 'PostgreSQL мощная база данных с открытым кодом'),
    ('JSONB в PostgreSQL', 'JSONB позволяет хранить JSON прямо в базе данных'),
    ('Партиционирование', 'Разбиение таблиц на части ускоряет запросы и упрощает обслуживание'),
    ('Полнотекстовый поиск', 'tsvector и tsquery позволяют искать слова с учётом морфологии');

#1 Поиск по оператору like для сравнения результатов
SELECT * FROM articles WHERE content LIKE '%база%';

#2 Добавление ts_vector колонки и проверка колонки
ALTER TABLE articles ADD COLUMN ts_vector TSVECTOR
GENERATED ALWAYS AS (to_tsvector('russian', title || ' ' || content)) STORED;
SELECT id, title, ts_vector FROM articles;

#3 Создание GIN индекса
CREATE INDEX idx_articles_fts ON articles USING GIN (ts_vector);
\d articles

#4 Поиск по двум словам логическое и
SELECT title
FROM articles
WHERE articles.ts_vector @@ to_tsquery('russian', 'база & данных');

#5 Поиск по двум словам логическое или
SELECT title
FROM articles
WHERE articles.ts_vector @@ to_tsquery('russian', 'jsonb | партиционирование');

#6 Ранжирование результатов по числу, которые присваивается при количестве совпадений (насколько этот запрос подходит)
SELECT title, ts_rank(ts_vector, to_tsquery('russian', 'postgresql ')) AS rank
FROM articles
WHERE articles.ts_vector @@ to_tsquery('russian', 'postgresql ')
ORDER BY rank DESC;

#7 Поиск по фразе <-> - оператор для оступа
SELECT title
FROM articles
WHERE articles.ts_vector @@ to_tsquery('russian', 'база <-> данных');
