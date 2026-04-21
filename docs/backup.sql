#Тренировка с бекапами

# 1) Создание SQL-дампа базы данных. Создаёт файл backup.sql с SQL-командами, которые полностью восстанавливают базу.
pg_dump -U postgres -d library_management -f backup.sql

# 2)Сжатый дамп (экономит место). -Fc — собственный сжатый формат PostgreSQL (не читается человеком)
pg_dump -U postgres -d library_management -Fc -f backup.dump


# 3) Бекап только схемы (без данных). -s — только схема (без данных)
pg_dump -U postgres -d library_management -s -f schema_only.sql

# 4) Бекап только данных (без схемы). -a — только данные (без схемы)
pg_dump -U postgres -d library_management -a -f data_only.sql


# 5) Восстановление из SQL-дампа. Создать пустую базу, восстановить из дампа
createdb -U postgres library_backup
psql -U postgres -d library_backup -f backup.sql

# 6) Восстановление из сжатого дампа
pg_restore -U postgres -d library_backup backup.dump

# 7) Бекап всех баз (pg_dumpall)
pg_dumpall -U postgres -f all_databases.sql
psql -U postgres -f all_databases.sql
