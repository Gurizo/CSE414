-- #1
CREATE TABLE Sales(
    name varchar(10),
    discount varchar(10),
    month varchar(10),
    price int
);

-- #2
-- 0 row 
-- name -> price
SELECT COUNT(*)
FROM Sales AS S1, Sales AS S2
WHERE S1.name = S2.name
AND S1.price != S2.price;

-- 0 row 
-- name -> discount, price
SELECT COUNT(*)
FROM Sales AS S1, Sales AS S2
WHERE S1.name = S2.name
AND S1.discount != S2.discount
AND S1.price != S2.price;

-- 0 row 
-- name -> month, price
SELECT COUNT(*)
FROM Sales AS S1, Sales AS S2
WHERE S1.name = S2.name
AND S1.month != S2.month
AND S1.price != S2.price;

-- 0 row 
-- name -> discount, month, price
SELECT COUNT(*)
FROM Sales AS S1, Sales AS S2
WHERE S1.name = S2.name
AND S1.discount != S2.discount
AND S1.month != S2.month
AND S1.price != S2.price;

-- 0 row 
-- month -> discount
SELECT COUNT(*)
FROM Sales AS S1, Sales AS S2
WHERE S1.month = S2.month
AND S1.discount != S2.discount;

-- 0 row 
-- month -> name, discount
SELECT COUNT(*)
FROM Sales AS S1, Sales AS S2
WHERE S1.month = S2.month
AND S1.name != S2.name
AND S1.discount != S2.discount;

-- 0 row 
-- month -> discount, price
SELECT COUNT(*)
FROM Sales AS S1, Sales AS S2
WHERE S1.month = S2.month
AND S1.discount != S2.discount
AND S1.price != S2.price;

-- 0 row 
-- month -> name, discount, price
SELECT COUNT(*)
FROM Sales AS S1, Sales AS S2
WHERE S1.month = S2.month
AND S1.name != S2.name
AND S1.discount != S2.discount
AND S1.price != S2.price;

-- 0 row 
-- name, discount -> price, discount
SELECT COUNT(*) 
FROM Sales AS S1, Sales AS S2
WHERE (S1.name = S2.name) and (S1.discount = S2.discount)
and (S1.price != S2.price) and (S1.month != S2.month);

-- 0 row 
-- month, price -> discount, name
SELECT COUNT(*) 
FROM Sales AS S1, Sales AS S2
WHERE (S1.month = S2.month) and (S1.price = S2.price)
and (S1.discount != S2.discount) and (S1.name != S2.name);

-- #3
CREATE TABLE Sales1(
	name VARCHAR(10) PRIMARY KEY,
	price INT
);

CREATE TABLE Sales2(
	month VARCHAR(10) PRIMARY KEY,
	discount VARCHAR(10)
);

CREATE TABLE Sales3(
	name VARCHAR(10) REFERENCES Sales1,
	month VARCHAR(10) REFERENCES Sales2
);

-- #4
-- 36 rows
-- bar1    19
-- bar8    19
-- gizmo3  19
-- gizmo7  19
-- mouse1  19
-- gizmo6  29
-- gizmo4  29
-- mouse3  29
-- mouse7  29
-- bar4    29
INSERT INTO Sales1
SELECT DISTINCT name, price 
FROM Sales;

-- 12 rows
-- apr     15%
-- aug     15%
-- dec     33%
-- feb     10%
-- jan     33%
-- jul     33%
-- jun     10%
-- mar     15%
-- may     10%
-- nov     15%
INSERT INTO Sales2
SELECT DISTINCT month, discount
FROM Sales;

-- 426 rows
-- bar1    apr
-- bar8    apr
-- gizmo3  apr
-- gizmo7  apr
-- mouse1  apr
-- bar1    aug
-- bar8    aug
-- gizmo3  aug
-- gizmo7  aug
-- mouse1  aug
INSERT INTO Sales3
SELECT DISTINCT name, month
FROM Sales;