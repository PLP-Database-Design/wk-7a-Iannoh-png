-- Option 1 (assuming MySQL or similar):
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

-- Option 2 (using a recursive CTE):
WITH RECURSIVE SplitProducts AS (
    SELECT
        OrderID,
        CustomerName,
        Products,
        SUBSTR(Products, 1, COALESCE(NULLIF(INSTR(Products, ','), 0) - 1, LENGTH(Products))) AS Product,
        SUBSTR(Products, COALESCE(NULLIF(INSTR(Products, ','), 0) + 1, LENGTH(Products) + 1)) AS RemainingProducts
    FROM
        OrderDetail
    UNION ALL
    SELECT
        OrderID,
        CustomerName,
        Products,
        SUBSTR(RemainingProducts, 1, COALESCE(NULLIF(INSTR(RemainingProducts, ','), 0) - 1, LENGTH(RemainingProducts))),
        SUBSTR(RemainingProducts, COALESCE(NULLIF(INSTR(RemainingProducts, ','), 0) + 1, LENGTH(RemainingProducts) + 1))
    FROM
        SplitProducts
    WHERE
        LENGTH(RemainingProducts) > 0
)
SELECT
    OrderID,
    CustomerName,
    TRIM(Product) AS Product
FROM
    SplitProducts
WHERE
    LENGTH(TRIM(Product)) > 0
ORDER BY
    OrderID;
