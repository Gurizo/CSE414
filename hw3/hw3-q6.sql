-- #6
-- 4 rows
-- Total execution time: 00:00:00.276
-- Alaska Airlines Inc.
-- SkyWest Airlines Inc.
-- United Air Lines Inc.
-- Virgin America
SELECT DISTINCT C.name as carrier
FROM CARRIERS as C, (
    SELECT F1.carrier_id
    FROM FLIGHTS F1 
    WHERE F1.origin_city = 'Seattle WA' AND F1.dest_city = 'San Francisco CA'
    GROUP BY F1.carrier_id
) AS F
WHERE F.carrier_id = c.cid
ORDER BY 
    carrier ASC;