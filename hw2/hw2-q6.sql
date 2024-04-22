// The number of rows in the query result: 3 rows

 SELECT C.name AS carrier, MAX(F.price) AS max_price
 FROM FLIGHTS AS F 
 JOIN CARRIERS AS C ON f.carrier_id = c.cid
 WHERE (F.origin_city = 'Seattle WA' or F.origin_city = 'New York NY') AND (F.dest_city = 'Seattle WA' OR F.dest_city = 'New York NY')
 GROUP BY C.name;