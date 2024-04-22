-- #5
-- 3 rows
-- Total execution time: 00:38:37.464
-- Devils Lake ND
-- Hattiesburg/Laurel MS
-- St. Augustine FL
SELECT DISTINCT F3.dest_city as city
FROM FLIGHTS F1
JOIN FLIGHTS F2 ON F1.dest_city = F2.origin_city AND F2.dest_city <> 'Seattle WA'
JOIN FLIGHTS F3 ON F2.dest_city = F3.origin_city AND F3.dest_city <> 'Seattle WA'
WHERE F1.origin_city = 'Seattle WA' 
EXCEPT (
    SELECT DISTINCT F2.dest_city
    FROM FLIGHTS F1 
    JOIN FLIGHTS F2 ON F1.dest_city = F2.origin_city
    WHERE F1.origin_city = 'Seattle WA' AND F2.dest_city <> 'Seattle WA'
)
ORDER BY 
    city ASC;