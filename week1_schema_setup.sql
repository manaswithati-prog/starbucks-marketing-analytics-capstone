-- ============================================
-- WEEK 1: Schema Setup & Data Validation
-- Starbucks Marketing Analytics Capstone
-- Manaswi Thati | WSU MS Marketing Analytics
-- ============================================

-- Create customers table
CREATE TABLE customers (
    customer_id NVARCHAR(50) PRIMARY KEY,
    gender NVARCHAR(10),
    age INT,
    income FLOAT,
    member_since INT
);

-- Create transactions table
CREATE TABLE transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id NVARCHAR(50),
    event_type NVARCHAR(50),
    value NVARCHAR(255),
    time INT
);

-- Create campaign_data table
CREATE TABLE campaign_data (
    offer_id NVARCHAR(50) PRIMARY KEY,
    offer_type NVARCHAR(50),
    difficulty INT,
    reward INT,
    duration INT,
    channels NVARCHAR(255)
);

-- Create channels table
CREATE TABLE channels (
    channel_id INT IDENTITY(1,1) PRIMARY KEY,
    channel_name NVARCHAR(100),
    sessions INT,
    clicks INT,
    impressions INT,
    conversions INT,
    ad_spend DECIMAL(12,2),
    revenue DECIMAL(12,2),
    bounce_rate FLOAT,
    avg_session_duration_sec FLOAT,
    report_date DATE
);

-- Create competitors table
CREATE TABLE competitors (
    competitor_id INT IDENTITY(1,1) PRIMARY KEY,
    brand_name NVARCHAR(100),
    avg_review_score FLOAT,
    total_reviews INT,
    monthly_web_traffic BIGINT,
    instagram_followers BIGINT,
    twitter_followers BIGINT,
    avg_price_usd FLOAT,
    data_collected_date DATE
);

-- ============================================
-- VALIDATION QUERIES
-- ============================================

-- Row count validation
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'campaign_data', COUNT(*) FROM campaign_data;

-- NULL check on customers
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS has_customer_id,
    COUNT(age) AS has_age,
    COUNT(gender) AS has_gender,
    COUNT(income) AS has_income
FROM customers;
