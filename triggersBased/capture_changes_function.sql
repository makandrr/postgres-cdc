CREATE OR REPLACE FUNCTION capture_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN -- log delete operation
        INSERT INTO users_cdc (user_id, operation_type, timestamp, username_before, email_before)
        VALUES (OLD.id, 'DELETE', NOW(), OLD.username, OLD.email);
    ELSIF (TG_OP = 'UPDATE') THEN -- log update operation
        INSERT INTO users_cdc (user_id, operation_type, timestamp, username_before, username_after, email_before, email_after)
        VALUES (NEW.id, 'UPDATE', NOW(), OLD.username, NEW.username, OLD.email, NEW.email);
    ELSIF (TG_OP = 'INSERT') THEN -- log insert operation
        INSERT INTO users_cdc (user_id, operation_type, timestamp, username_after, email_after)
        VALUES (NEW.id, 'INSERT', NOW(), NEW.username, NEW.email);
    END IF;

    RETURN NEW;
END
$$;