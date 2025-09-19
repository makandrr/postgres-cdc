-- subscriber db

CREATE SUBSCRIPTION my_subscription CONNECTION 'host=pg_publisher port=5432 dbname=publisher_db user=replicator password=repl_password123'
PUBLICATION my_publication;

-- check
SELECT * FROM pg_subscription;
SELECT * FROM pg_stat_subscription;
