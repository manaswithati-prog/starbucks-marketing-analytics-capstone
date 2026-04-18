-- ============================================
-- WEEK 5: Digital Channel Audit SQL Queries
-- Starbucks Marketing Analytics Capstone
-- Manaswi Thati | WSU MS Marketing Analytics
-- ============================================

-- W5_Q1: Channel Overview - Record counts and totals by channel
SELECT
    channel_name,
    COUNT(*) AS total_records,
    SUM(clicks) AS total_clicks,
    SUM(impressions) AS total_impressions,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(ad_spend), 2) AS total_ad_spend,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM channels
GROUP BY channel_name
ORDER BY total_revenue DESC;

-- W5_Q2: CTR and Conversion Rate by Channel
SELECT
    channel_name,
    SUM(clicks) AS total_clicks,
    SUM(impressions) AS total_impressions,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(clicks) * 100.0 / NULLIF(SUM(impressions), 0), 4) AS ctr_pct,
    ROUND(SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0), 2) AS conversion_rate_pct
FROM channels
GROUP BY channel_name
ORDER BY conversion_rate_pct DESC;

-- W5_Q3: ROAS and CPA by Channel
SELECT
    channel_name,
    ROUND(SUM(ad_spend), 2) AS total_ad_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS cpa
FROM channels
GROUP BY channel_name
ORDER BY roas DESC;

-- W5_Q4: Last-Touch Attribution - Revenue Share by Channel
SELECT
    channel_name,
    ROUND(SUM(revenue), 2) AS channel_revenue,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER(), 2) AS revenue_share_pct,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(conversions) * 100.0 / SUM(SUM(conversions)) OVER(), 2) AS conversion_share_pct
FROM channels
GROUP BY channel_name
ORDER BY revenue_share_pct DESC;

-- W5_Q5: Master Channel Comparison Table (All Metrics + Performance Tier)
SELECT
    channel_name,
    COUNT(*) AS total_records,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(ad_spend), 2) AS total_ad_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(clicks) * 100.0 / NULLIF(SUM(impressions), 0), 4) AS ctr_pct,
    ROUND(SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0), 2) AS conversion_rate_pct,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS cpa,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER(), 2) AS revenue_share_pct,
    CASE
        WHEN ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) >= 2.0 THEN 'Top Performer'
        WHEN ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) >= 1.0 THEN 'Moderate'
        ELSE 'Underperformer'
    END AS performance_tier
FROM channels
GROUP BY channel_name
ORDER BY roas DESC;
