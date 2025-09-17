ALTER SYSTEM SET wal_level = 'logical';
ALTER SYSTEM SET max_wal_senders = 3;
ALTER SYSTEM SET max_replication_slots =3;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    product_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'repl_password123';
GRANT SELECT ON ALL TABLES IN SCHEMA public to replicator;
GRANT USAGE ON SCHEMA public to replicator;

INSERT INTO users (username, email) VALUES 
    ('john_doe', 'john@example.com'),
    ('jane_smith', 'jane@example.com'),
    ('bob_wilson', 'bob@example.com');

INSERT INTO orders (user_id, product_name, quantity, price) VALUES 
    (1, 'Laptop', 1, 999.99),
    (2, 'Mouse', 2, 29.99),
    (1, 'Keyboard', 1, 79.99);