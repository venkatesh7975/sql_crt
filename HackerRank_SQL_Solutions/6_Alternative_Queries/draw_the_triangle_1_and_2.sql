-- Draw The Triangle 1 (MySQL)
SET @row := 21;
SELECT REPEAT('* ', @row := @row - 1) FROM information_schema.tables LIMIT 20;

-- Draw The Triangle 2 (MySQL)
SET @row := 0;
SELECT REPEAT('* ', @row := @row + 1) FROM information_schema.tables LIMIT 20;
