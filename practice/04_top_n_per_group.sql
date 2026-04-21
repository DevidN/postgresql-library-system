#Используя твою текущую нормализованную схему (authors, books, editions, book_authors), для каждого автора нужно найти три самые новые книги (по году издания).
WITH 
	latest_editions AS(
			SELECT book_id, MAX(published_year) AS py
			FROM editions
			GROUP BY book_id
		),
		
	author_books AS(
	SELECT 
	a.name, 
	b.title,
	ROW_NUMBER() OVER (PARTITION BY a.id ORDER BY le.py DESC) as RowNum
	
	FROM books b
	JOIN book_authors ba ON b.id = ba.book_id
	JOIN authors a ON ba.author_id = a.id
	JOIN editions e ON b.id = e.book_id
	JOIN latest_editions le ON b.id = le.book_id
	)

SELECT *
FROM author_books as ab
WHERE  ab.RowNum <= 3;
