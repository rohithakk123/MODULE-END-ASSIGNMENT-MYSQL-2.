USE ecomm;

-- 12. Average satisfaction score of customers who have complained
SELECT AVG(SatisfactionScore) AS Avg_Satisfaction 
FROM customer_churn 
WHERE ComplaintReceived = 'Yes';

-- 13. Preferred order categories among customers who used more than 5 coupons
SELECT DISTINCT PreferredOrderCat 
FROM customer_churn 
WHERE CouponUsed > 5;

-- 14. Top 3 preferred order categories with highest average cashback
SELECT PreferredOrderCat, AVG(CashbackAmount) AS Avg_Cashback 
FROM customer_churn 
GROUP BY PreferredOrderCat 
ORDER BY Avg_Cashback DESC 
LIMIT 3;

-- 15. Preferred payment modes for avg tenure 10 months & > 500 orders
SELECT DISTINCT PreferredPaymentMode 
FROM customer_churn 
GROUP BY PreferredPaymentMode, CustomerID 
HAVING AVG(Tenure) = 10 AND SUM(OrderCount) > 500;

-- 16. Distance category thirich ulla churn status breakdown
SELECT 
    CASE 
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS Distance_Category,
    ChurnStatus,
    COUNT(*) AS Total_Customers
FROM customer_churn
GROUP BY Distance_Category, ChurnStatus;

-- 17. Customer order details: Married, City Tier-1, & > average order count
SELECT * 
FROM customer_churn 
WHERE MaritalStatus = 'Married' 
  AND CityTier = 1 
  AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn);

-- -------------------------------------------------------------
-- Final Section: Customer Returns Table Creation & Join Analysis
-- -------------------------------------------------------------

-- a) Create customer_returns table & Insert data
DROP TABLE IF EXISTS customer_returns;
CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT
);

INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) 
VALUES 
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

-- b) Return details along with customer details (Churned & Complained)
SELECT cr.*, cd.*
FROM customer_returns cr
JOIN customer_churn cd ON cr.CustomerID = cd.CustomerID
WHERE cd.ChurnStatus = 'Churned' 
  AND cd.ComplaintReceived = 'Yes';