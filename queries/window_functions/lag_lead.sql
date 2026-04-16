#Вывести для книг только Толстого:название книги, год издания, год предыдущего издания этой же книги, год следующего издания этой же книги
SELECT 
b.title,
e.published_year,
LAG(e.published_year) OVER (PARTITION BY b.id ORDER BY e.published_year) AS prev_year,
LEAD(e.published_year) OVER (PARTITION BY b.id ORDER BY e.published_year) AS next_year
FROM editions e
JOIN books b ON e.book_id = b.id
JOIN book_authors ba ON b.id = ba.book_id
JOIN authors a ON ba.author_id = a.id
WHERE a.name = 'Лев Толстой'
ORDER BY b.title, e.published_year;
