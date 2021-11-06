D:
cd D:\Kyzure\NUS\Current\CS2102\cs2102-project\dump
pg_dump --username=postgres --column-inserts --data-only --no-owner cs2102_ptest > cs2102_dump.sql