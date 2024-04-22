SELECT I.category AS category, SR.rep_name AS name
FROM Items AS I
JOIN ItemSales AS ISales ON I.item_no = ISales.item_no
JOIN Transactions AS T ON ISales.txn_id = T.txn_id
JOIN SalesReps AS SR ON T.rep_id = SR.rep_id
GROUP BY I.category, SR.rep_name
HAVING SUM(ISales.quantity) = (
    SELECT MAX(total_quantity)
    FROM (
        SELECT I.category, SR.rep_name, SUM(ISales.quantity) AS total_quantity
        FROM Items AS I
        JOIN ItemSales AS ISales ON I.item_no = ISales.item_no
        JOIN Transactions AS T ON ISales.txn_id = T.txn_id
        JOIN SalesReps AS SR ON T.rep_id = SR.rep_id
        GROUP BY I.category, SR.rep_name
    ) AS subquery
    WHERE subquery.category = I.category
)
ORDER BY I.category ASC;


-- SELECT *
-- FROM (
--     SELECT SR.rep_id, MAX(T.txn_day) AS mtd, COUNT(*) AS cnt
--     FROM Transactions T
--     JOIN SalesReps AS SR ON T.rep_id = SR.rep_id
--     WHERE T.txn_day > 1500
--     GROUP BY SR.rep_id
-- ) AS subquery
-- WHERE mtd > 1900;