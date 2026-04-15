-- Найти всех авторов, у которых больше одной книги, а потом вывести все их книги (название, год).

-- Создал временную таблицу, сделал выборку авторов, у которых больше 1 книги
WITH rich_authors AS(
SELECT author_id
FROM books
GROUP BY author_id
HAVING COUNT(*) > 1
)
SELECT a.name, b.title, b.published_year
FROM books b
INNER JOIN authors a ON b.author_id = a.id
-- Использовал эту конструкция, т.к. она лучше для чтения + если бы были дубликаты, inner join умножил бы их 
WHERE b.author_id IN (SELECT author_id FROM rich_authors)
ORDER BY a.name, b.published_year;

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


-- Найти всех авторов, у которых хотя бы одна книга выдана. Вывести имена авторов без дубликатов.
WITH borrowed_books AS(
SELECT author_id, is_borrowed
FROM books
WHERE is_borrowed = TRUE
)

SELECT DISTINCT a.name
FROM authors a
INNER JOIN borrowed_books ON a.id = borrowed_books.author_id;

