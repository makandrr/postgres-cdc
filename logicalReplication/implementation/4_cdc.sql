CREATE OR REPLACE FUNCTION log_cdc_changes()
RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'DELETE' THEN
		INSERT INTO public.cdc_log (table_name, operation, old_data, new_data)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), NULL);
		RETURN OLD;
	ELSIF TG_OP = 'UPDATE' THEN
		INSERT INTO public.cdc_log (table_name, operation, old_data, new_data)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW));
	ELSIF TG_OP = 'INSERT' THEN
		INSERT INTO public.cdc_log (table_name, operation, old_data, new_data)
		VALUES (TG_TABLE_NAME, TG_OP, NULL, row_to_json(NEW));
	END IF;
	RETURN NULL;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_cdc_trigger
	AFTER INSERT OR UPDATE OR DELETE ON users
	FOR EACH ROW EXECUTE FUNCTION log_cdc_changes();

CREATE TRIGGER orders_cdc_trigger
	AFTER INSERT OR UPDATE OR DELETE ON orders
	FOR EACH ROW EXECUTE FUNCTION log_cdc_changes();