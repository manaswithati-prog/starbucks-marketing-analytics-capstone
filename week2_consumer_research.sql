-- ============================================
-- WEEK 2: Consumer Research SQL Queries
-- Starbucks Marketing Analytics Capstone
-- Manaswi Thati | WSU MS Marketing Analytics
-- ============================================

-- Q1: Age Distribution by Generation
SELECT
    CASE
        WHEN age < 25 THEN 'Gen Z (Under 25)'
        WHEN age BETWEEN 25 AND 40 THEN 'Millennial (25-40)'
        WHEN age BETWEEN 41 AND 56 THEN 'Gen X (41-56)'
        ELSE 'Boomer+ (57+)'
    END AS age_group,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM customers
GROUP BY
    CASE
        WHEN age < 25 THEN 'Gen Z (Under 25)'
        WHEN age BETWEEN 25 AND 40 THEN 'Millennial (25-40)'
        WHEN age BETWEEN 41 AND 56 THEN 'Gen X (41-56)'
        ELSE 'Boomer+ (57+)'
    END
ORDER BY customer_count DESC;

-- Q2: Gender Breakdown
SELECT
    gender,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM customers
GROUP BY gender
ORDER BY customer_count DESC;

-- Q3: Income Segmentation
SELECT
    CASE
        WHEN income < 40000 THEN 'Low Income (Under $40K)'
        WHEN income BETWEEN 40000 AND 75000 THEN 'Middle Income ($40K-$75K)'
        WHEN income BETWEEN 75001 AND 120000 THEN 'Upper Middle ($75K-$120K)'
        ELSE 'High Income (Over $120K)'
    END AS income_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(income), 0) AS avg_income
FROM customers
GROUP BY
    CASE
        WHEN income < 40000 THEN 'Low Income (Under $40K)'
        WHEN income BETWEEN 40000 AND 75000 THEN 'Middle Income ($40K-$75K)'
        WHEN income BETWEEN 75001 AND 120000 THEN 'Upper Middle ($75K-$120K)'
        ELSE 'High Income (Over $120K)'
    END
ORDER BY avg_income;

-- Q4: Membership Growth by Year
SELECT
    member_since AS join_year,
    COUNT(*) AS new_members,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM customers
GROUP BY member_since
ORDER BY join_year;

-- Q5: Transaction Event Type Breakdown
SELECT
    event_type,
    COUNT(*) AS total_events,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM transactions
GROUP BY event_type
ORDER BY total_events DESC;

-- Q6: Offer Completion Rate by Offer Type
SELECT
    cd.offer_type,
    COUNT(CASE WHEN t.event_type = 'offer received' THEN 1 END) AS received,
    COUNT(CASE WHEN t.event_type = 'offer completed' THEN 1 END) AS completed,
    ROUND(COUNT(CASE WHEN t.event_type = 'offer completed' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN t.event_type = 'offer received' THEN 1 END), 0), 1) AS completion_pct
FROM transactions t
JOIN campaign_data cd ON t.value LIKE '%' + cd.offer_id + '%'
WHERE t.event_type IN ('offer received', 'offer completed')
GROUP BY cd.offer_type;

-- Q7: NPS Proxy Calculation
SELECT
    CASE
        WHEN transaction_count >= 10 THEN 'Promoter (High Engagement)'
        WHEN transaction_count BETWEEN 5 AND 9 THEN 'Passive (Low Engagement)'
        ELSE 'Detractor (Low Engagement)'
    END AS nps_segment,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM (
    SELECT customer_id, COUNT(*) AS transaction_count
    FROM transactions
    WHERE event_type = 'transaction'
    GROUP BY customer_id
) AS customer_transactions
GROUP BY
    CASE
        WHEN transaction_count >= 10 THEN 'Promoter (High Engagement)'
        WHEN transaction_count BETWEEN 5 AND 9 THEN 'Passive (Low Engagement)'
        ELSE 'Detractor (Low Engagement)'
    END;

-- Q8: Average Transactions per Customer by Age Group
SELECT
    CASE
        WHEN c.age < 25 THEN 'Gen Z'
        WHEN c.age BETWEEN 25 AND 40 THEN 'Millennial'
        WHEN c.age BETWEEN 41 AND 56 THEN 'Gen X'
        ELSE 'Boomer+'
    END AS age_group,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(COUNT(t.transaction_id) * 1.0 / COUNT(DISTINCT c.customer_id), 1) AS avg_transactions
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.event_type = 'transaction'
GROUP BY
    CASE
        WHEN c.age < 25 THEN 'Gen Z'
        WHEN c.age BETWEEN 25 AND 40 THEN 'Millennial'
        WHEN c.age BETWEEN 41 AND 56 THEN 'Gen X'
        ELSE 'Boomer+'
    END
ORDER BY avg_transactions DESC;

-- Q9: Gender x Offer Type Preference
SELECT
    c.gender,
    cd.offer_type,
    COUNT(*) AS completed_offers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY c.gender), 1) AS pct_within_gender
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN campaign_data cd ON t.value LIKE '%' + cd.offer_id + '%'
WHERE t.event_type = 'offer completed'
    AND c.gender IN ('M', 'F')
GROUP BY c.gender, cd.offer_type
ORDER BY c.gender, completed_offers DESC;

-- Q10: Income vs Engagement
SELECT
    CASE
        WHEN c.income < 40000 THEN 'Low Income'
        WHEN c.income BETWEEN 40000 AND 75000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(COUNT(t.transaction_id) * 1.0 / COUNT(DISTINCT c.customer_id), 1) AS avg_transactions
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.event_type = 'transaction'
GROUP BY
    CASE
        WHEN c.income < 40000 THEN 'Low Income'
        WHEN c.income BETWEEN 40000 AND 75000 THEN 'Middle Income'
        ELSE 'High Income'
    END
ORDER BY avg_transactions DESC;
