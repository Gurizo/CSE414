CREATE TABLE MONTHS (
    mid int PRIMARY KEY, 
    month varchar(9)
    );

CREATE TABLE WEEKDAYS (
    did int PRIMARY KEY, 
    day_of_week varchar(9)
    );

CREATE TABLE CARRIERS (
    cid varchar(7) PRIMARY KEY, 
    name varchar(83)
    );

CREATE TABLE FLIGHTS (fid int PRIMARY KEY, 
         month_id int REFERENCES MONTHS(mid),        -- 1-12
         day_of_month int,    -- 1-31 
         day_of_week_id int REFERENCES WEEKDAYS(did),  -- 1-7, 1 = Monday, 2 = Tuesday, etc
         carrier_id varchar(7) REFERENCES CARRIERS(cid), 
         flight_num int,
         origin_city varchar(34), 
         origin_state varchar(47), 
         dest_city varchar(34), 
         dest_state varchar(46), 
         departure_delay int, -- in mins
         taxi_out int,        -- in mins
         arrival_delay int,   -- in mins
         canceled int,        -- 1 means canceled
         actual_time int,     -- in mins
         distance int,        -- in miles
         capacity int, 
         price int            -- in $             
         );
        
bulk insert Carriers from 'carriers.csv'
with (ROWTERMINATOR = '0x0a',
DATA_SOURCE = 'flightdata_blob', FORMAT='CSV', CODEPAGE = 65001, --UTF-8 encoding
FIRSTROW=1,TABLOCK);

bulk insert Months from 'months.csv'
with (ROWTERMINATOR = '0x0a',
DATA_SOURCE = 'flightdata_blob', FORMAT='CSV', CODEPAGE = 65001, --UTF-8 encoding
FIRSTROW=1,TABLOCK);

bulk insert Weekdays from 'weekdays.csv'
with (ROWTERMINATOR = '0x0a',
DATA_SOURCE = 'flightdata_blob', FORMAT='CSV', CODEPAGE = 65001, --UTF-8 encoding
FIRSTROW=1,TABLOCK);

-- Import for the large Flights table.
-- This last import might take a little under 10 minutes on the
-- provided server settings
bulk insert Flights from 'flights-small.csv'
with (ROWTERMINATOR = '0x0a',
DATA_SOURCE = 'flightdata_blob', FORMAT='CSV', CODEPAGE = 65001, --UTF-8 encoding
FIRSTROW=1,TABLOCK);

-- Indexes, which we’ll discuss later this quarter, will make your
-- homework queries run much faster (optional, but STRONGLY recommended).
-- In aggregate, these three statements will take about 10 minutes
create index Flights_idx1 on Flights(origin_city,dest_city,actual_time);
create index Flights_idx2 on Flights(actual_time);
create index Flights_idx3 on Flights(dest_city,origin_city,actual_time);

--#1
SELECT F1.origin_city, F1.dest_city, MAX(F2.actual_time) as time 
FROM FLIGHTS as F1,
     FLIGHTS as F2
WHERE F1.origin_city = F2.origin_city
GROUP BY F1.origin_city, F1.dest_city, F1.actual_time
HAVING F1.actual_time = MAX(F2.actual_time)
ORDER BY
  F1.origin_city ASC,
  F1.dest_city ASC

--sub query method with duplicated origin_city value--
WITH LongestFlight AS 
    (SELECT F1.origin_city, MAX(F1.actual_time) AS time
       FROM FLIGHTS as F1
   GROUP BY F1.origin_city)
SELECT F.origin_city, F.dest_city, LF.time
  FROM FLIGHTS AS F, LongestFlight as LF
 WHERE F.origin_city = LF.origin_city AND F.actual_time = LF.time
 ORDER BY
  F.origin_city ASC,
  F.dest_city ASC

--#2
SELECT F.origin_city as city
FROM FLIGHTS AS F
WHERE NOT EXISTS (
    SELECT 1
    FROM FLIGHTS AS F1
    WHERE
        F1.origin_city = F.origin_city AND
        F1.actual_time >= 180
) 
GROUP BY F.origin_city
ORDER BY 
    F.origin_city ASC


--#3
SELECT F.origin_city as origin_city, 
    (CAST(ISNULL(SUM(CASE WHEN F.canceled = 0 AND F.actual_time < 180 THEN 1 ELSE 0 END), 0) AS DECIMAL) /
    ISNULL(SUM(CASE WHEN F.canceled = 0 THEN 1 ELSE 0 END), 0)) * 100 AS percentage
FROM FLIGHTS AS F
GROUP BY 
  F.origin_city
ORDER BY 
  percentage ASC, 
  F.origin_city ASC;

--#4
SELECT DISTINCT F2.dest_city as city
FROM FLIGHTS as F1
JOIN FLIGHTS as F2 ON F1.dest_city = F2.origin_city AND F1.canceled = 0 AND F2.canceled = 0
WHERE F1.origin_city = 'Seattle WA' AND F2.dest_city <> 'Seattle WA'
AND NOT EXISTS (
    SELECT 1 
    FROM FLIGHTS as F3
    WHERE F3.origin_city = 'Seattle WA' AND F3.dest_city = F2.dest_city AND F3.canceled = 0
)
ORDER BY 
    city ASC;

--#5
SELECT DISTINCT F3.dest_city as city
FROM FLIGHTS as F1
JOIN FLIGHTS as F2 ON F1.dest_city = F2.origin_city
JOIN FLIGHTS F3 ON F2.dest_city = F3.origin_city AND F1.origin_city = 'Seattle WA' 
WHERE F3.dest_city <> 'Seattle WA' 
EXCEPT
SELECT F2.dest_city
FROM FLIGHTS as F1
JOIN FLIGHTS as F2 ON F1.dest_city = F2.origin_city
WHERE F1.origin_city = 'Seattle WA'
ORDER BY 
    city ASC;
    
--#6
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

--#7
SELECT DISTINCT C.name as carrier
FROM FLIGHTS F  
JOIN CARRIERS AS C ON F.carrier_id = c.cid
WHERE F.origin_city = 'Seattle WA' AND F.dest_city = 'San Francisco CA'

--#8


select * FROM FLIGHTS



