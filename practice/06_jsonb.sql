DROP TABLE IF EXISTS events;
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    event_data JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO events (event_data) VALUES
    ('{"user_id": 1, "action": "login", "ip": "192.168.1.1"}'),
    ('{"user_id": 2, "action": "purchase", "amount": 500, "items": ["book", "pen"]}'),
    ('{"user_id": 1, "action": "logout", "ip": "192.168.1.1"}'),
    ('{"user_id": 3, "action": "view", "page": "/catalog"}'),
    ('{"user_id": 2, "action": "login", "ip": "192.168.1.10"}');

#1
SELECT 
event_data->>'user_id' AS user_id,
event_data->> 'action' AS action
FROM events;

#2
SELECT *
FROM events
WHERE event_data @> '{"action": "login"}';

#3
SELECT *
FROM events
WHERE event_data ? 'items';

#4
SELECT event_data->>'items' AS items
FROM events
WHERE event_data @> '{"items": ["book"]}';

#5
CREATE INDEX idx_events_jsonb ON events USING GIN (event_data);
EXPLAIN ANALYZE SELECT * FROM events WHERE event_data @> '{"action": "login"}';

#6
UPDATE events
SET event_data = event_data || '{"session_id ": "abc123"}'
WHERE events.id = 1;

#7
UPDATE events 
SET event_data = event_data - 'session_id'
WHERE id = 1;
