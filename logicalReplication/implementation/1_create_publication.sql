CREATE PUBLICATION my_publication FOR ALL TABLES;

-- check
SELECT * FROM pg_publication;
SELECT * FROM pg_publication_tables;