-- Найти книги, год публикации которых больше года публикации любой книги автора Джордж Оруэлл

SELECT title, published_year
FROM books
WHERE published_year > ANY (
    SELECT published_year
    FROM books
    WHERE author_id = (SELECT id FROM authors WHERE name = 'Джордж Оруэлл')
);
