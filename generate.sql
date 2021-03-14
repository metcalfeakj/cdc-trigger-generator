-- Written by Alex Metcalfe
-- Developed and tested on MySQL 8.0.23

-- Use table name as parameter to create CDC table.

create table if not exists ?
(
    cdc_id       int auto_increment
        primary key,
    message      blob     not null,
    process_date datetime null
);


-- Set schema and table name in variables below.
-- After code is executed, extract SQL code from each row in second column to review before executing.

select @schemaName := 'data_warehouse';
select @tableName := 'party';
SELECT col1,
       CONCAT('CREATE TRIGGER cdc_', concat(@tableName, '_', col1), '
    ', col2, '
    ON ', concat(@schemaName, '.', @tableName), '
    FOR EACH ROW
BEGIN
    INSERT INTO cdc_', @tableName, '(message)
    VALUES (JSON_OBJECT(', concat(quote('cdc_type'), ' ,', quote(col1), ', '),
              (SELECT concat((SELECT CASE
                                         WHEN col1 <> 'INS' THEN GROUP_CONCAT(
                                                 quote(concat('old_', COLUMN_NAME)), ', old.', COLUMN_NAME
                                                 SEPARATOR ','
                                             )
                                         else '' END),
                             (select CASE WHEN col1 = 'UPD' THEN ',' else '' END),
                             (SELECT CASE
                                         WHEN col1 <> 'DEL' THEN GROUP_CONCAT(
                                                 QUOTE(COLUMN_NAME), ', new.', COLUMN_NAME
                                                 SEPARATOR ','
                                             )
                                         else '' END))
               FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME = 'party'),
              '
                            ));end;') as code
FROM (SELECT 'INS' as col1, 'AFTER INSERT' as col2
      UNION ALL
      SELECT 'UPD' as col1, 'AFTER UPDATE' as col2
      UNION ALL
      SELECT 'DEL' as col1, 'AFTER DELETE' as col2) as triggers;
