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
