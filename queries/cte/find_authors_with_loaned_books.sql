-- Найти всех авторов, у которых хотя бы одна книга выдана. Вывести имена авторов без дубликатов.
WITH borrowed_books AS(
SELECT author_id, is_borrowed
FROM books
WHERE is_borrowed = TRUE
)

SELECT DISTINCT a.name
FROM authors a
INNER JOIN borrowed_books ON a.id = borrowed_books.author_id;
