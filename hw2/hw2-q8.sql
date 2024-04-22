// The number of rows in the query result: 22 rows

SELECT C.name AS name, SUM(F.departure_delay) AS delay
 FROM FLIGHTS AS F 
 JOIN CARRIERS AS C ON f.carrier_id = c.cid
GROUP BY C.name;