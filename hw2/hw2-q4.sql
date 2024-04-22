// The number of rows in the query result: 12 rows

SELECT DISTINCT C.name
FROM FLIGHTS AS F JOIN CARRIERS AS C ON F.carrier_id = c.cid
GROUP BY F.carrier_id, F.month_id, day_of_month
HAVING COUNT(*) > 1000;