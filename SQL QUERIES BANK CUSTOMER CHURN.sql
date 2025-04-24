												BANK CUSTOMER CHURN ANALYSIS


CREATE TABLE bank_customers (
    customer_id INTEGER PRIMARY KEY,
	credit_score INTEGER,
	geography TEXT,
	gender TEXT,
	age INTEGER,
	tenure INTEGER,
	account_balance_euro NUMERIC,
	num_of_products INTEGER,
	has_cr_card INTEGER,
	is_active_member INTEGER,
	exited INTEGER,
	reason_for_churn TEXT,
	credit_category TEXT,
	account_type TEXT,
	customer_rating INTEGER,
	account_opening_date DATE
);

ALTER TABLE bank_customers
ALTER COLUMN exited TYPE BOOLEAN
USING exited::BOOLEAN;


ALTER TABLE bank_customers
ALTER COLUMN has_cr_card TYPE BOOLEAN
USING has_cr_card::BOOLEAN;

-- 1. What is the overall churn rate?
SELECT 
    ROUND(100.0 * SUM(CASE WHEN exited THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percentage
FROM bank_customers;


-- 2. Which country has the highest churn rate?
SELECT 
    geography,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN exited THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percentage
FROM bank_customers
GROUP BY geography
ORDER BY churn_rate_percentage DESC;

-- 3. What is the average age and balance of churned vs retained customers?
SELECT 
    exited,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(account_balance_euro), 2) AS avg_balance
FROM bank_customers
GROUP BY exited;

-- 4. What are the top reasons customers gave for churn?
SELECT 
    reason_for_churn,
    COUNT(*) AS total
FROM bank_customers
WHERE exited = TRUE
GROUP BY reason_for_churn
ORDER BY total DESC
LIMIT 10;

-- 5. Does having a credit card affect churn?
SELECT 
    has_cr_card,
    SUM(CASE WHEN exited THEN 1 ELSE 0 END) AS churned,
    COUNT(*) AS total,
    ROUND(100.0 * SUM(CASE WHEN exited THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM bank_customers
GROUP BY has_cr_card;

-- 6. Churn rate by customer rating (1–5 stars)?
SELECT 
    customer_rating,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN exited THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM bank_customers
GROUP BY customer_rating
ORDER BY customer_rating;


-- 7. How does churn differ by number of products used?
SELECT 
    num_of_products,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN exited THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM bank_customers
GROUP BY num_of_products
ORDER BY num_of_products;


-- 8. What tenure range sees the highest churn?
SELECT 
    tenure,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN exited THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM bank_customers
GROUP BY tenure
ORDER BY churn_rate DESC
LIMIT 5;


-- 9. How many customers churned in each year?
SELECT 
    EXTRACT(YEAR FROM account_opening_date) AS join_year,
    COUNT(*) FILTER (WHERE exited) AS churned_customers,
    COUNT(*) AS total_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE exited) / COUNT(*), 2) AS churn_rate
FROM bank_customers
GROUP BY join_year
ORDER BY join_year;


-- 10. Which combination of account type and geography shows the highest churn?
SELECT 
    geography,
    account_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN exited THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM bank_customers
GROUP BY geography, account_type
ORDER BY churn_rate DESC
LIMIT 10;


