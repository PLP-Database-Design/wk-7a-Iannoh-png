
SELECT
    OrderDetail.OrderID,
    OrderDetail.CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OrderDetail.Products, ',', n.n), ',', -1)) AS Product
FROM
    OrderDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5
) n
WHERE
    LENGTH(OrderDetail.Products) - LENGTH(REPLACE(OrderDetail.Products, ',', '')) >= n - 1
ORDER BY
    OrderDetail.OrderID;

