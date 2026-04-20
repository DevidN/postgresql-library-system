#Условие:В таблице books_old есть дубликаты названий. Нужно удалить все дубликаты, оставив только одну строку для каждого названия (любую, например, с минимальным id).

DELETE FROM books_old bo1
USING books_old bo2
WHERE bo1.ctid > bo2.ctid
AND bo1.title = bo2.title;
