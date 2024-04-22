// The number of rows in the query result: 1472 rows

SELECT F1.carrier_id, F1.flight_num, F1.origin_city, F1.dest_city, F1.actual_time,
       F2.flight_num, F2.origin_city, F2.dest_city, F2.actual_time, F1.actual_time+F2.actual_time
FROM FLIGHTS as F1 JOIN FLIGHTS F2 ON f1.dest_city = f2.origin_city AND f1.carrier_id = f2.carrier_id
WHERE F1.month_id = 7 AND F1.day_of_month = 15 AND F2.month_id = 7 AND F2.day_of_month = 15 AND 
      F1.origin_city = 'Seattle WA' AND F2.dest_city = 'Boston MA' AND F1.actual_time+F2.actual_time < 420;

