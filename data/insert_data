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
