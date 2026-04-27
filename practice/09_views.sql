
#1) Обычное представление (просто сохраненный запрос)
CREATE VIEW books_with_authors AS
SELECT b.title, a.name, e.published_year
FROM books b
INNER JOIN book_authors ba ON b.id = ba.book_id
INNER JOIN authors a ON ba.author_id = a.id
INNER JOIN editions e ON b.id = e.book_id

SELECT * 
FROM books_with_authors
WHERE name = 'Лев Толстой'
  
#2) Материализованное представление (создает таблицу)
CREATE MATERIALIZED VIEW mv_books_with_authors AS
SELECT b.title, a.name, e.published_year
FROM books b
INNER JOIN book_authors ba ON b.id = ba.book_id
INNER JOIN authors a ON ba.author_id = a.id
INNER JOIN editions e ON b.id = e.book_id

#3) Обновление материализованного представления (обновляет значения и все связи)
REFRESH MATERIALIZED VIEW mv_books_with_authors;


#4) Сравнение производительности. Значения различаются сильно, т.к. в материализованном представлении данные уже лежат в таблице, а в обычном представлнении это просто сохраненный запрос
EXPLAIN ANALYZE SELECT * FROM books_with_authors
WHERE name = 'Фёдор Достоевский'
#cost = 21.45 actual time = 0.105

EXPLAIN ANALYZE SELECT * FROM mv_books_with_authors
WHERE name = 'Фёдор Достоевский'
#cost = 0.00 ... 0.20 actual time = 0.018-0.019

#5) Индекс можно создать только на материализованном представлении
CREATE INDEX idx_name_book_with_authors ON mv_books_with_authors (name);
EXPLAIN ANALYZE SELECT * FROM mv_books_with_authors WHERE name = 'Фёдор Достоевский';
