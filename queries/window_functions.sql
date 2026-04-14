#1) Добавить нумерацию книг в порядке возрастания года публикации (от самой старой к новой). Нумерация начинается заново для каждого автора

SELECT 
a.name,
b.title, 
b.published_year,
ROW_NUMBER() OVER(PARTITION BY a.name ORDER BY a.name, b.published_year ASC) as row_id
FROM books b
INNER JOIN authors a ON b.author_id = a.id;

#2) Добавить книгу с одинаковым годом у одного автора, выполнить запрос с RANK() вместо ROW_NUMBER(), сравнить результат
INSERT INTO books (title, author_id, published_year, is_borrowed) VALUES ('Письма', 1, 1869, FALSE);

SELECT 
a.name,
b.title, 
b.published_year,
RANK() OVER(PARTITION BY a.name ORDER BY a.name, b.published_year ASC) as row_id
FROM books b
INNER JOIN authors a ON b.author_id = a.id;

# Разница в том, что в RANK при дубликате получают одинаковый порядковый номер, а при ROW_NUMBER +1

#3) Написать запрос, который для каждой книги выводит:автора, название, год публикации, средний год публикации по всем книгам этого автора (рядом в каждой строке)

SELECT 
a.name,
b.title, 
b.published_year,
AVG (b.published_year) OVER (PARTITION BY a.name)
FROM books b
INNER JOIN authors a ON b.author_id = a.id;

#GROUP_BY неприминимо т.к. он сворачивает множество строк в одну группу, тогда как оконные функции добавляют к значение к каждой строке
