-- ============================================
-- WEEK 4: Competitive Intelligence SQL Queries
-- Starbucks Marketing Analytics Capstone
-- Manaswi Thati | WSU MS Marketing Analytics
-- ============================================

-- Q1: Review Score Comparison Across Brands
SELECT
    brand_name,
    avg_review_score,
    ROUND(AVG(avg_review_score) OVER(), 2) AS vs_industry_avg,
    RANK() OVER (ORDER BY avg_review_score DESC) AS review_rank
FROM competitors
ORDER BY avg_review_score DESC;

-- Q2: Price vs Value Positioning
SELECT
    brand_name,
    avg_price_usd,
    avg_review_score,
    RANK() OVER (ORDER BY avg_price_usd ASC) AS affordability_rank,
    ROUND(avg_review_score / avg_price_usd, 2) AS value_score
FROM competitors
ORDER BY value_score DESC;

-- Q3: Social Media Footprint Comparison
SELECT
    brand_name,
    instagram_followers,
    twitter_followers,
    instagram_followers + twitter_followers AS total_social_followers,
    RANK() OVER (ORDER BY instagram_followers + twitter_followers DESC) AS social_rank,
    ROUND((instagram_followers + twitter_followers) * 100.0 /
        SUM(instagram_followers + twitter_followers) OVER(), 1) AS market_share_pct
FROM competitors
ORDER BY total_social_followers DESC;

-- Q4: Full Competitive Scorecard (Window Functions)
SELECT
    brand_name,
    avg_review_score,
    avg_price_usd,
    monthly_web_traffic,
    instagram_followers + twitter_followers AS total_social,
    RANK() OVER (ORDER BY avg_review_score DESC) AS quality_rank,
    RANK() OVER (ORDER BY avg_price_usd ASC) AS affordability_rank,
    RANK() OVER (ORDER BY monthly_web_traffic DESC) AS web_rank,
    RANK() OVER (ORDER BY instagram_followers + twitter_followers DESC) AS social_rank
FROM competitors
ORDER BY avg_review_score DESC;
