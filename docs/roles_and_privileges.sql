
#Создаем роль и выдаем права на чтение таблицы authors
CREATE ROLE library_user WITH LOGIN PASSWORD '123456';
GRANT SELECT ON authors TO library_user;

#Выдаем и забираем права на вставку строк таблицы authors
GRANT INSERT ON authors TO library_user;
REVOKE INSERT ON authors FROM library_user;

#Проверка прав на таблице
\dp authors

#создаем групповую роль
CREATE ROLE read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only;
GRANT read_only TO library_user;

#удаляем групповую роль, но перед удалением нужно отобрать права и членство в других ролях
REVOKE read_only FROM library_user;
DROP ROLE read_only;
DROP ROLE library_user;
