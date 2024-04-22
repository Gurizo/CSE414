// The number of rows in the query result: 1 row

SELECT CASE F.day_of_week_id 
            WHEN 1 THEN 'Monday'
            WHEN 2 THEN 'Tuesday'
            WHEN 3 THEN 'Wednesday'
            WHEN 4 THEN 'Thursday'
            WHEN 5 THEN 'Friday'
            WHEN 6 THEN 'Saturday'
            WHEN 7 THEN 'Sunday'
            END as day_of_week, AVG(F.arrival_delay) as delay
FROM FLIGHTS as F
GROUP BY day_of_week_id
ORDER BY delay DESC
LIMIT 1;

