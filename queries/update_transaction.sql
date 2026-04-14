# Задача: Библиотекарь выдал книгу 'Война и мир' читателю. Нужно изменить статус этой книги на true.
UPDATE books
SET is_borrowed = TRUE
WHERE books.title = 'Война и мир'
RETURNING*;

# Задача: Библиотекарь начал оформлять выдачу книги «Преступление и наказание», но в последний момент читатель передумал. Изменение нужно отменить, не трогая остальные данные.
BEGIN;

UPDATE books
SET is_borrowed = TRUE
WHERE books.title = 'Преступление и наказание'
RETURNING is_borrowed;

ROLLBACK;

# Задача: Библиотекарь выдал книгу «Братья Карамазовы» успешно

BEGIN;

UPDATE books
SET is_borrowed = TRUE
WHERE books.title = 'Преступление и наказание'
RETURNING is_borrowed;

COMMIT;
