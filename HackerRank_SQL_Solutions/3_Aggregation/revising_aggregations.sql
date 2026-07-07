-- Revising Aggregations - The Count Function
SELECT COUNT(NAME) FROM CITY WHERE POPULATION > 100000;

-- Revising Aggregations - The Sum Function
SELECT SUM(POPULATION) FROM CITY WHERE DISTRICT = 'California';

-- Revising Aggregations - Averages
SELECT AVG(POPULATION) FROM CITY WHERE DISTRICT = 'California';
