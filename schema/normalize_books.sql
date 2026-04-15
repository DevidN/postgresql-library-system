-- Задача по оптимизации бд с правилами 2nf, 3nf
-- Моя текущая таблица books нарушает 2NF и 3NF, если у книги появится несколько изданий. (неключевой столбец зависит от составного ключа, все что не ключ должно зависить от ключа)

-- Создаем таблицы, наполняем их данными из books, перейменовываем books в books_old
CREATE TABLE book_authors (
    book_id INTEGER REFERENCES books(id),
    author_id INTEGER REFERENCES authors(id),
    PRIMARY KEY (book_id, author_id)
);


CREATE TABLE editions (
    id SERIAL PRIMARY KEY,
    book_id INTEGER REFERENCES books(id) NOT NULL,
    published_year INTEGER CHECK (published_year > 1499),
    is_borrowed BOOLEAN DEFAULT FALSE
);

INSERT INTO book_authors (book_id, author_id)
SELECT id, author_id FROM books;

INSERT INTO editions (book_id, published_year, is_borrowed)
SELECT id, published_year, is_borrowed FROM books;

ALTER TABLE books RENAME TO books_old;
