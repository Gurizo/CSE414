// The number of rows in the query result: 6 rows

SELECT C.name AS name, ROUND((SUM(f.canceled) * 100.0 / COUNT(*)), 1) AS percentage
FROM FLIGHTS as F
JOIN CARRIERS as C ON f.carrier_id = c.cid
WHERE F.origin_city = 'Seattle WA'
GROUP BY f.carrier_id, C.name 
HAVING (SUM(f.canceled) * 100.0 / COUNT(*)) > 0.5
ORDER BY percentage ASC;