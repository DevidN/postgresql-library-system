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
