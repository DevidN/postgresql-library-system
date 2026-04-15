-- Найти книги, год публикации которых больше года публикации любой книги автора Джордж Оруэлл

SELECT title, published_year
FROM books
WHERE published_year > ANY (
    SELECT published_year
    FROM books
    WHERE author_id = (SELECT id FROM authors WHERE name = 'Джордж Оруэлл')
);

-- Найти книги, год публикации которых больше года публикации любой книги автора Лев Толстой
SELECT b.title, b.published_year
FROM books b
WHERE b.published_year > ANY (
    SELECT published_year
    FROM books
    WHERE author_id = (SELECT id FROM authors WHERE name = 'Лев Толстой')
);
