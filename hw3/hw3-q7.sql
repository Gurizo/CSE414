-- #7
-- 4 rows
-- Total execution time: 00:00:00.288
-- Alaska Airlines Inc.
-- SkyWest Airlines Inc.
-- United Air Lines Inc.
-- Virgin America
SELECT DISTINCT C.name as carrier
FROM FLIGHTS F  
JOIN CARRIERS AS C ON F.carrier_id = c.cid
WHERE F.origin_city = 'Seattle WA' AND F.dest_city = 'San Francisco CA'
ORDER BY 
    carrier ASC;
