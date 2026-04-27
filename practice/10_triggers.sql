-- Добавляем колонку updated_at в authors
ALTER TABLE authors ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();

-- Создаём таблицу для аудита (логов изменений)
DROP TABLE IF EXISTS authors_log;
CREATE TABLE authors_log (
    id SERIAL PRIMARY KEY,
    author_id INTEGER,
    action TEXT,
    old_name TEXT,
    new_name TEXT,
    changed_at TIMESTAMPTZ DEFAULT NOW()
);


#1) Триггер для обновления updated_at
CREATE OR REPLACE FUNCTION authors_updated_at()
RETURNS TRIGGER AS $$
BEGIN
	NEW.updated_at = now();
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_authors
BEFORE UPDATE ON authors
FOR EACH ROW
EXECUTE FUNCTION authors_updated_at()

#2) Проверить работу триггера updated_at
UPDATE authors SET name = 'Лев Николаевич Толстой' WHERE id = 1;
SELECT id, name, updated_at FROM authors WHERE id = 1;

#3) Триггер для логирования (аудит)
CREATE OR REPLACE FUNCTION author_log() RETURNS TRIGGER AS $author_log$

BEGIN
	IF(TG_OP = 'DELETE') THEN
		INSERT INTO authors_log (author_id, action, old_name, new_name, changed_at) VALUES (old.id, 'DELETE', old.name, NULL, now());
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO authors_log (author_id, action, old_name, new_name, changed_at) VALUES (old.id, 'UPDATE', old.name, new.name, now());
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO authors_log (author_id, action, old_name, new_name, changed_at) VALUES (new.id, 'INSERT', NULL, new.name, now());
	END IF;
    RETURN NULL;
END;

$author_log$ LANGUAGE plpgsql;

CREATE TRIGGER author_log_trg
AFTER INSERT OR DELETE OR UPDATE ON authors
FOR EACH ROW EXECUTE FUNCTION author_log();

UPDATE authors SET name = 'Тест' WHERE id = 1;
SELECT * FROM authors_log;
