#Начинал так, теперь схема пришла к другому виду (для себя, чтобы понимать к чему пришел за весь проект)

#заходим в бд через psql
psql -U postgres -d library_management

#Создаем таблицы
CREATE TABLE books (id SERIAL PRIMARY KEY, 
title TEXT NOT NULL, 
author_id INTEGER REFERENCES authors(id),
published_year INTEGER, 
is_borrowed BOOL DEFAULT FALSE, 
CONSTRAINT chk_published_year CHECK (published_year>1499));

CREATE TABLE authors (id SERIAL PRIMARY KEY, 
name TEXT NOT NULL, 
country TEXT, born_year INTEGER);

#Проверяем созданные таблицы
\dt
\d books
\d authors

#заходим в бд через psql
psql -U postgres -d library_management

INSERT INTO authors (name, country, born_year) VALUES
    ('Лев Толстой', 'Россия', 1828),
    ('Фёдор Достоевский', 'Россия', 1821),
    ('Джордж Оруэлл', 'Великобритания', 1903);

INSERT INTO books (title, author_id, published_year, is_borrowed) VALUES
    ('Война и мир', 1, 1869, false),
    ('Анна Каренина', 1, 1877, true),
    ('Преступление и наказание', 2, 1866, false),
    ('Братья Карамазовы', 2, 1880, false),
    ('1984', 3, 1949, true);
