// The number of rows in the query result: 1 row

 SELECT SUM(F.capacity) AS capacity
 FROM FLIGHTS AS F 
 WHERE (F.origin_city = 'Seattle WA' OR F.origin_city = 'San Francisco CA') AND (F.dest_city = 'Seattle WA' OR F.dest_city = 'San Francisco CA') AND
       (F.month_id = 7 AND F.day_of_month = 10);


JOIN CARRIERS AS C ON f.carrier_id = c.cid