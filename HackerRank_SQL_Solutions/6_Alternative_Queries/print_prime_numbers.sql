-- Print Prime Numbers (MySQL)
-- Generates prime numbers <= 1000 and prints them as a '&' separated string
WITH RECURSIVE numbers AS (
    SELECT 2 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 1000
)
SELECT GROUP_CONCAT(n1.n SEPARATOR '&')
FROM numbers n1
WHERE NOT EXISTS (
    SELECT 1 FROM numbers n2
    WHERE n2.n <= SQRT(n1.n) AND n1.n % n2.n = 0
);
