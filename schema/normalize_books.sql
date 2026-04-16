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

-- Создаем таблицу books и делаем миграцию данных в предыдущие таблицы т.к. значения из них ссылаются на books, но она теперь books_old

CREATE TABLE books(
id SERIAL PRIMARY KEY,
title TEXT NOT NULL
);

INSERT INTO books (title) SELECT DISTINCT title FROM books_old;

ALTER TABLE book_authors ADD COLUMN new_book_id INTEGER;

# Производим миграцию данных через создание новой колонки в таблице
UPDATE book_authors as ba
SET new_book_id = b.id
FROM books_old AS bo
JOIN books AS b ON bo.title = b.title
WHERE ba.book_id = bo.id;

# удаляем book_id, меняем new_book_id на book_id и возвращаем PKKEY и NOTNULL ограничение
ALTER TABLE book_authors DROP COLUMN book_id;
ALTER TABLE book_authors RENAME COLUMN new_book_id TO book_id;
ALTER TABLE book_authors ALTER COLUMN book_id SET NOT NULL;
ALTER TABLE book_authors ADD CONSTRAINT fk_book_authors_book FOREIGN KEY (book_id) REFERENCES books(id);
ALTER TABLE book_authors ADD PRIMARY KEY (book_id, author_id);

#Делаем аналогичную миграцию данных для таблицы 

