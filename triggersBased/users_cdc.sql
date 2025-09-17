CREATE TABLE users_cdc (
    cdc_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    timestamp TIMESTAMP,
    operation_type VARCHAR(10),
    username_before VARCHAR(100),
    username_after VARCHAR(100),
    email_before VARCHAR(100),
    email_after VARCHAR(100)
);