-- #2
-- 109 rows
-- Total execution time: 00:00:04.953
-- Aberdeen SD
-- Abilene TX
-- Alpena MI
-- Ashland WV
-- Augusta GA
-- Barrow AK
-- Beaumont/Port Arthur TX
-- Bemidji MN
-- Bethel AK
-- Binghamton NY
-- Brainerd MN
-- Bristol/Johnson City/Kingsport TN
-- Butte MT
-- Carlsbad CA
-- Casper WY
-- Cedar City UT
-- Chico CA
-- College Station/Bryan TX
-- Columbia MO
-- Columbus GA
SELECT F.origin_city as city
FROM FLIGHTS AS F
WHERE NOT EXISTS (
    SELECT 1
    FROM FLIGHTS AS F1
    WHERE
        F1.origin_city = F.origin_city AND
        F1.actual_time >= 180
) 
GROUP BY F.origin_city
ORDER BY 
    F.origin_city ASC

