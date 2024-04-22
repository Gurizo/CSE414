-- #4
-- 256 rows
-- Total execution time: 00:00:21.753
-- Aberdeen SD
-- Abilene TX
-- Adak Island AK
-- Aguadilla PR
-- Akron OH
-- Albany GA
-- Albany NY
-- Alexandria LA
-- Allentown/Bethlehem/Easton PA
-- Alpena MI
-- Amarillo TX
-- Appleton WI
-- Arcata/Eureka CA
-- Asheville NC
-- Ashland WV
-- Aspen CO
-- Atlantic City NJ
-- Augusta GA
-- Bakersfield CA
-- Bangor ME
SELECT DISTINCT F2.dest_city as city
FROM FLIGHTS as F1
JOIN FLIGHTS as F2 ON F1.dest_city = F2.origin_city AND F1.canceled = 0 AND F2.canceled = 0
WHERE F1.origin_city = 'Seattle WA' AND F2.dest_city <> 'Seattle WA'
AND NOT EXISTS (
    SELECT 1 
    FROM FLIGHTS as F3
    WHERE F3.origin_city = 'Seattle WA' AND F3.dest_city = F2.dest_city AND F3.canceled = 0
)
ORDER BY 
    city ASC;
