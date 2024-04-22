-- #3
-- 327 rows
-- Total execution time: 00:00:17.264
-- Guam TT	0.00000000000
-- Pago Pago TT	0.00000000000
-- Aguadilla PR	28.89733840300
-- Anchorage AK	31.81208053600
-- San Juan PR	33.66053169700
-- Charlotte Amalie VI	39.55882352900
-- Ponce PR	40.98360655700
-- Fairbanks AK	50.11655011600
-- Kahului HI	53.51447135200
-- Honolulu HI	54.73902882300
-- San Francisco CA	55.82886453700
-- Los Angeles CA	56.08089082200
-- Seattle WA	57.60938779200
-- Long Beach CA	62.17643951300
-- New York NY	62.37183413600
-- Kona HI	63.16079295100
-- Las Vegas NV	64.92025637200
-- Christiansted VI	65.10067114000
-- Newark NJ	65.84997109600
-- Plattsburgh NY	66.66666666600
SELECT F.origin_city as origin_city, 
    (CAST(ISNULL(SUM(CASE WHEN F.canceled = 0 AND F.actual_time < 180 THEN 1 ELSE 0 END), 0) AS DECIMAL) /
    ISNULL(SUM(CASE WHEN F.canceled = 0 THEN 1 ELSE 0 END), 0)) * 100 AS percentage
FROM FLIGHTS AS F
GROUP BY 
  F.origin_city
ORDER BY 
  percentage ASC, 
  F.origin_city ASC;

