#создаем временную колонку для миграции данных в таблицу book_authors
ALTER TABLE book_authors ADD COLUMN new_book_id INTEGER;

# Производим миграцию данных
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

#Делаем аналогичную миграцию данных для таблицы издания
ALTER TABLE editions ADD COLUMN new_book_id INTEGER;

UPDATE editions as e
SET new_book_id = b.id
FROM books_old AS bo
JOIN books AS b ON bo.title = b.title
WHERE e.book_id = bo.id;

ALTER TABLE editions DROP COLUMN book_id;
ALTER TABLE editions RENAME COLUMN new_book_id TO book_id;
ALTER TABLE editions ALTER COLUMN book_id SET NOT NULL;
ALTER TABLE editions ADD CONSTRAINT fk_editions_book FOREIGN KEY (book_id) REFERENCES books(id);
