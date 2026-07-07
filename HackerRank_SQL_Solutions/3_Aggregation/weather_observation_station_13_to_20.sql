-- Weather Observation Station 13
SELECT TRUNCATE(SUM(LAT_N), 4) FROM STATION WHERE LAT_N > 38.7880 AND LAT_N < 137.2345;

-- Weather Observation Station 14
SELECT TRUNCATE(MAX(LAT_N), 4) FROM STATION WHERE LAT_N < 137.2345;

-- Weather Observation Station 15
SELECT ROUND(LONG_W, 4) FROM STATION WHERE LAT_N = (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N < 137.2345);

-- Weather Observation Station 16
SELECT ROUND(MIN(LAT_N), 4) FROM STATION WHERE LAT_N > 38.7780;

-- Weather Observation Station 17
SELECT ROUND(LONG_W, 4) FROM STATION WHERE LAT_N = (SELECT MIN(LAT_N) FROM STATION WHERE LAT_N > 38.7780);

-- Weather Observation Station 18
SELECT ROUND(ABS(MIN(LAT_N) - MAX(LAT_N)) + ABS(MIN(LONG_W) - MAX(LONG_W)), 4) FROM STATION;

-- Weather Observation Station 19
SELECT ROUND(SQRT(POWER(MAX(LAT_N) - MIN(LAT_N), 2) + POWER(MAX(LONG_W) - MIN(LONG_W), 2)), 4) FROM STATION;

-- Weather Observation Station 20 (Median)
SET @rowindex := -1;
SELECT ROUND(AVG(d.LAT_N), 4) as Median 
FROM (
   SELECT @rowindex:=@rowindex + 1 AS rowindex, STATION.LAT_N AS LAT_N
   FROM STATION
   ORDER BY STATION.LAT_N
) AS d
WHERE d.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));
