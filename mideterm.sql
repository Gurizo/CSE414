DROP TABLE IF EXISTS ItemSales
DROP TABLE IF EXISTS Transactions
DROP TABLE IF EXISTS Items
DROP TABLE IF EXISTS SalesReps

CREATE TABLE Items (
    item_no INT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    price FLOAT NOT NULL,
    rating INT NOT NULL,
    category VARCHAR(255) NOT NULL
);

CREATE TABLE SalesReps (
    rep_id INT PRIMARY KEY,
    rep_name VARCHAR(255) NOT NULL,
    start_day INT NOT NULL
);

CREATE TABLE Transactions (
    txn_day INT NOT NULL,
    txn_id INT PRIMARY KEY,
    rep_id INT NOT NULL REFERENCES SalesReps
);

CREATE TABLE ItemSales (
    item_no INT NOT NULL REFERENCES Items,
    txn_id INT NOT NULL REFERENCES Transactions,
    quantity INT NOT NULL,
    PRIMARY KEY (item_no, txn_id)
);

INSERT INTO Items VALUES
  (8001, 'backpack', 74.99, 4, 'hiking'),
  (8002, 'jacket', 124.99, 3, 'hiking'),
  (8003, 'helmet', 164.99, 5, 'snow');
INSERT INTO SalesReps VALUES
  (901, 'Vince Offer', 11),
  (902, 'Billy Mays', 22);
INSERT INTO Transactions VALUES
  (56, 10001, 901),
  (59, 10002, 902);
INSERT INTO ItemSales VALUES
  (8001, 10001, 1),
  (8002, 10001, 2),
  (8001, 10002, 1),
  (8003, 10002, 1);

INSERT INTO Items VALUES
  (8004, 'othree', 333.33, 2, 'gang')

INSERT INTO ItemSales VALUES
  (8002, 10002, 1)


--4
SELECT DISTINCT S.rep_name AS name
FROM SalesReps AS S
WHERE S.start_day > 100
ORDER BY S.rep_name ASC

--5
SELECT DISTINCT S.rep_name AS name
FROM SalesReps AS S
LEFT JOIN Transactions AS T ON S.rep_id = T.rep_id
WHERE S.start_day > T.txn_day
ORDER BY S.rep_name ASC

--6
SELECT T.txn_day AS sale_day, SUM(ISale.quantity*I.price) AS total_sold
FROM Transactions AS T
LEFT JOIN ItemSales As ISale ON T.txn_id = ISale.txn_id
INNER JOIN Items As I ON ISale.item_no = I.item_no
GROUP BY T.txn_day
ORDER BY T.txn_day

--7
SELECT TOP (
  SELECT COUNT(DISTINCT item_name) 
  FROM Items
) I1.item_name AS item, I2.rep, I2.quantity
FROM Items as I1
INNER JOIN (
  SELECT I.item_name AS item, S.rep_name AS rep, CASE WHEN sum(ISale.quantity) IS NULL THEN 0 ELSE sum(ISale.quantity) END AS quantity, 
  ROW_NUMBER() OVER (PARTITION BY I.item_name ORDER BY quantity DESC) AS num
  FROM SalesReps AS S
  LEFT JOIN Transactions AS T ON S.rep_id = T.rep_id
  LEFT JOIN ItemSales AS ISale ON T.txn_id = ISale.txn_id
  RIGHT JOIN Items AS I ON ISale.item_no = I.item_no
  GROUP BY I.item_name, S.rep_name, Isale.quantity 
) AS I2 ON I1.item_name = I2.item
ORDER BY
  I2.num,
  I1.item_name ASC,
  I2.quantity DESC

--8
SELECT DISTINCT I.category AS category, COUNT(CASE WHEN rating > 3 THEN 1 END) AS high_rated, 
COUNT(CASE WHEN rating <  4 THEN 1 END) AS low_rated
FROM Items AS I
GROUP BY category
ORDER BY category ASC


--9
SELECT DISTINCT S1.rep_name AS name
FROM SalesReps AS S1
EXCEPT
SELECT S.rep_name
FROM SalesReps AS S
LEFT JOIN Transactions AS T ON S.rep_id = T.rep_id
INNER JOIN ItemSales AS ISale ON T.txn_id = ISale.txn_id
INNER JOIN Items AS I ON ISale.item_no = I.item_no AND I.item_name = 'jacket'
GROUP BY S.rep_name
ORDER BY S1.rep_name ASC





SELECT * FROM Transactions AS T 
INNER JOIN ItemSales AS ISale ON T.txn_id = ISale.txn_id
INNER JOIN Items AS I ON ISale.item_no = I.item_no 
INNER JOIN SalesReps AS S ON S.rep_id = T.rep_id

--4. 
SELECT rep_name AS name
FROM SalesReps
WHERE start_day > 100
ORDER BY rep_name ASC;

--5.
SELECT DISTINCT rep_name AS name
FROM SalesReps s
JOIN Transactions t ON s.rep_id = t.rep_id
WHERE s.start_day > t.txn_day
ORDER BY rep_name ASC;

--6.
SELECT t.txn_day AS sale_day, SUM(i.price * s.quantity) AS total_sold
FROM Transactions t
JOIN ItemSales s ON t.txn_id = s.txn_id
JOIN Items i ON s.item_no = i.item_no
GROUP BY t.txn_day
ORDER BY sale_day ASC;

--7.
SELECT item, rep, quantity
FROM (
  SELECT i.item_name AS item, sr.rep_name AS rep, SUM(s.quantity) AS quantity,
         ROW_NUMBER() OVER (PARTITION BY i.item_name ORDER BY SUM(s.quantity) DESC) as rn
  FROM Items i
  LEFT JOIN ItemSales s ON i.item_no = s.item_no
  LEFT JOIN Transactions t ON s.txn_id = t.txn_id
  LEFT JOIN SalesReps sr ON t.rep_id = sr.rep_id
  GROUP BY i.item_name, sr.rep_name
) sub
WHERE rn = 1
ORDER BY item ASC;


--8.
SELECT category, 
COUNT(CASE WHEN rating >= 4 THEN item_no END) AS high_rated,
COUNT(CASE WHEN rating < 4 THEN item_no END) AS low_rated
FROM Items
GROUP BY category
ORDER BY category ASC;

--9.
SELECT DISTINCT sr1.rep_name AS name
FROM SalesReps AS sr1
EXCEPT
SELECT sr2.rep_name
FROM SalesReps AS sr2
JOIN Transactions AS t ON sr2.rep_id = t.rep_id
JOIN ItemSales AS s ON t.txn_id = s.txn_id
JOIN Items AS i ON s.item_no = i.item_no
AND i.item_name = 'jacket'
GROUP BY sr2.rep_name
ORDER BY name ASC;


select * from ItemSales