#Вывести для каждого издания всех книг:название книги, год издания, самый ранний год издания этой книги (первое издание), самый поздний год издания этой книги (последнее издание)
WITH other_publications AS(
SELECT book_id, COUNT(book_id)
FROM editions
GROUP BY book_id
HAVING COUNT(book_id) > 1
)

SELECT b.title,
e.published_year,
FIRST_VALUE(e.published_year) OVER(PARTITION BY b.title) AS first_year,
LAST_VALUE(e.published_year) OVER(PARTITION BY b.title) AS last_year
FROM books b
JOIN editions e ON b.id = book_id
JOIN other_publications op ON e.id = op.book_id
ORDER BY b.title, e.published_year;
