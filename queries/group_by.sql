#Напиши запрос, который выведет количество книг каждого автора.
Результат должен быть таким:
text
    name     | book_count 
-------------+------------
 Лев Толстой | 2
 Фёдор Достоевский | 2
 Джордж Оруэлл | 1

SELECT a.id, a.name, COUNT(b.id) AS book_count
FROM authors a
INNER JOIN books b ON a.id = b.author_id
GROUP BY a.id, a.name;

#если сделать без id и в a.name будут 2 одинаковых ФИО они склеятся в одну строку
