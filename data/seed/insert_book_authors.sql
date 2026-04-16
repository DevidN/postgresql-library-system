INSERT INTO book_authors (book_id, author_id)
SELECT b.id, a.id
FROM books b, authors a
WHERE (b.title = 'Война и мир' AND a.name = 'Лев Толстой')
   OR (b.title = 'Анна Каренина' AND a.name = 'Лев Толстой')
   OR (b.title = 'Письма' AND a.name = 'Лев Толстой')
   OR (b.title = 'Преступление и наказание' AND a.name = 'Фёдор Достоевский')
   OR (b.title = 'Братья Карамазовы' AND a.name = 'Фёдор Достоевский')
   OR (b.title = '1984' AND a.name = 'Джордж Оруэлл');
