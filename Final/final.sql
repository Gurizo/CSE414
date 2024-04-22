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
  (8003, 'helmet', 164.99, 5, 'snow'),
  (8004, 'tent', 1640.99, 5, 'hiking'),
  (8005, 'water', 1.99, 5, 'climbing');
INSERT INTO SalesReps VALUES
  (901, 'Vince Offer', 11),
  (902, 'Billy Mays', 22);
INSERT INTO Transactions VALUES
  (900, 10001, 901),
  (900, 10002, 902),
  (990, 10003, 902),
  (58, 10004, 902);
INSERT INTO ItemSales VALUES
  (8001, 10001, 1),
  (8002, 10001, 2),
  (8001, 10002, 1),
  (8003, 10002, 1),
  (8003, 10001, 3),
  (8002, 10002, 1),
  (8005, 10002, 1),
  (8003, 10003, 1),
  (8004, 10003, 1),
  (8001, 10004, 1),
  (8002, 10004, 1),
  (8003, 10004, 1),
  (8004, 10004, 1);
