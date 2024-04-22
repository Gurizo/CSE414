// The number of rows in the query result: 3 rows

SELECT DISTINCT F.flight_num
FROM FLIGHTS as F
WHERE F.day_of_week_id = 1 AND F.origin_city = 'Seattle WA' AND F.dest_city = 'Boston MA' AND F.carrier_id = 'AS';
