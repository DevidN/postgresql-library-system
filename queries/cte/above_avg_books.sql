-- Найти авторов, у которых книг больше среднего (по всем авторам).
-- Создал временную таблицу book_counts и запросил ид аторов и количество строк, сгруппировав их по ид автору
WITH book_counts AS(
SELECT author_id, COUNT(books.author_id) AS book_count
FROM books
GROUP BY author_id 
),
  
-- Создал временную таблицу avg_count, запросил данные из предыдущей, затем сравнил количество строк со средним значением
avg_count AS(
SELECT author_id
FROM book_counts 
WHERE book_count > (SELECT AVG (book_count) FROM book_counts)
)

-- выбрал все имена, где ид равен ид из avg_count
SELECT a.name
FROM authors a
WHERE a.id IN (SELECT author_id FROM avg_count);
