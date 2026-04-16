INSERT INTO editions (book_id, published_year, is_borrowed)
SELECT b.id, e_data.published_year, e_data.is_borrowed
FROM books b
JOIN (
    VALUES
        ('Война и мир', 1869, true),
        ('Анна Каренина', 1877, true),
        ('Письма', 1869, false),
        ('Преступление и наказание', 1866, false),
        ('Братья Карамазовы', 1880, true),
        ('1984', 1949, true)
) AS e_data(title, published_year, is_borrowed) ON b.title = e_data.title;
