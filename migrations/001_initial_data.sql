#Вставляем данные в book_authors и editions из books, затем перейменовываем таблицы в books_old. Затем вставляем в новую таблицу books названия книг из books_old
INSERT INTO book_authors (book_id, author_id)
SELECT id, author_id FROM books;

INSERT INTO editions (book_id, published_year, is_borrowed)
SELECT id, published_year, is_borrowed FROM books;

ALTER TABLE books RENAME TO books_old;

INSERT INTO books (title) SELECT DISTINCT title FROM books_old;
