#1) Написать запрос, который выведет: название книги, имя автора
SELECT b.title, a.name
FROM books b
INNER JOIN authors a ON b.author_id = a.id

#Использовал Алиасы, получил все строки, которые совпали в таблицах

#2) Написать запрос, который выведет: название книги, имя автора
SELECT b.title, a.name
FROM books b
LEFT JOIN authors a ON b.author_id = a.id

#Получил все строки, которые совпали с правой таблицей, но вывелась доп строка с Булгаковым и в поле название книги NULL

#3) Написать запрос, который показывает все свободные книги
SELECT b.title, a.name, b.is_borrowed
FROM books b
INNER JOIN authors a ON b.author_id = a.id
WHERE b.is_borrowed = FALSE;
