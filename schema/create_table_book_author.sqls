#Создаем таблицу авторы книги

CREATE TABLE book_authors (
    book_id INTEGER REFERENCES books(id),
    author_id INTEGER REFERENCES authors(id),
    PRIMARY KEY (book_id, author_id)
);
