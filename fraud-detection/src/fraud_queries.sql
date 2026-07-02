-- ============================================================
-- Financial Fraud Detection — SQL Analysis Layer
-- Author: Your Name
-- Purpose: Business-level queries for fraud risk segmentation
-- Database: SQLite / PostgreSQL compatible
-- ============================================================

-- ── 0. Create base table (run once) ────────────────────────────────────
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id        TEXT PRIMARY KEY,
    amount                REAL,
    hour                  INTEGER,
    country               TEXT,
    channel               TEXT,
    transactions_last_24h INTEGER,
    days_as_customer      INTEGER,
    is_fraud              INTEGER
);

-- ── 1. Overall fraud summary ────────────────────────────────────────────
SELECT
    COUNT(*)                                        AS total_transactions,
    SUM(is_fraud)                                   AS total_fraud,
    ROUND(AVG(is_fraud) * 100, 2)                   AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN is_fraud=1 THEN amount END),2) AS total_fraud_value,
    ROUND(AVG(CASE WHEN is_fraud=1 THEN amount END),2) AS avg_fraud_amount,
    ROUND(AVG(CASE WHEN is_fraud=0 THEN amount END),2) AS avg_legit_amount
FROM transactions;


-- ── 2. Fraud rate by hour — identify high-risk windows ─────────────────
SELECT
    hour,
    COUNT(*)                                  AS txn_count,
    SUM(is_fraud)                             AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 2)            AS fraud_rate_pct,
    CASE
        WHEN hour >= 23 OR hour <= 2 THEN '🔴 HIGH RISK'
        WHEN hour >= 20 OR hour <= 5 THEN '🟡 ELEVATED'
        ELSE '🟢 NORMAL'
    END AS risk_window
FROM transactions
GROUP BY hour
ORDER BY fraud_rate_pct DESC;


-- ── 3. Country risk segmentation ────────────────────────────────────────
SELECT
    COALESCE(country, 'Unknown')             AS country,
    COUNT(*)                                 AS total_txns,
    SUM(is_fraud)                            AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 2)           AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN is_fraud=1
              THEN amount END), 2)           AS fraud_value,
    CASE
        WHEN AVG(is_fraud) > 0.20 THEN 'CRITICAL'
        WHEN AVG(is_fraud) > 0.10 THEN 'HIGH'
        WHEN AVG(is_fraud) > 0.05 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_level
FROM transactions
GROUP BY country
HAVING COUNT(*) > 50
ORDER BY fraud_rate_pct DESC;


-- ── 4. Channel performance analysis ────────────────────────────────────
SELECT
    channel,
    COUNT(*)                                 AS total_txns,
    ROUND(AVG(is_fraud) * 100, 2)           AS fraud_rate_pct,
    ROUND(AVG(amount), 2)                    AS avg_amount,
    ROUND(SUM(CASE WHEN is_fraud=1
              THEN amount END), 2)           AS total_fraud_value,
    ROUND(SUM(CASE WHEN is_fraud=1
              THEN amount END) /
          NULLIF(SUM(amount),0) * 100, 2)   AS fraud_value_pct_of_total
FROM transactions
GROUP BY channel
ORDER BY fraud_rate_pct DESC;


-- ── 5. High-risk customer segments ─────────────────────────────────────
-- Identifies the customer profiles most associated with fraud
SELECT
    CASE
        WHEN days_as_customer < 30  THEN '0-30 days (NEW)'
        WHEN days_as_customer < 90  THEN '31-90 days'
        WHEN days_as_customer < 365 THEN '91-365 days'
        ELSE '365+ days (LOYAL)'
    END AS customer_tenure_band,
    COUNT(*)                                 AS total_txns,
    ROUND(AVG(is_fraud) * 100, 2)           AS fraud_rate_pct,
    ROUND(AVG(amount), 2)                    AS avg_transaction
FROM transactions
GROUP BY customer_tenure_band
ORDER BY fraud_rate_pct DESC;


-- ── 6. Velocity analysis — transactions_last_24h ────────────────────────
SELECT
    CASE
        WHEN transactions_last_24h = 0 THEN '0'
        WHEN transactions_last_24h <= 2 THEN '1-2'
        WHEN transactions_last_24h <= 5 THEN '3-5'
        WHEN transactions_last_24h <= 10 THEN '6-10'
        ELSE '10+ (HIGH VELOCITY)'
    END AS velocity_band,
    COUNT(*)                                 AS txn_count,
    ROUND(AVG(is_fraud) * 100, 2)           AS fraud_rate_pct
FROM transactions
GROUP BY velocity_band
ORDER BY fraud_rate_pct DESC;


-- ── 7. Combined high-risk flag — executive alert query ──────────────────
-- Returns transactions meeting multiple risk criteria simultaneously
SELECT
    transaction_id,
    amount,
    hour,
    country,
    channel,
    transactions_last_24h,
    days_as_customer,
    is_fraud,
    (
        CASE WHEN hour >= 23 OR hour <= 2 THEN 2 ELSE 0 END +
        CASE WHEN country IN ('Nigeria','Romania','Unknown') THEN 3 ELSE 0 END +
        CASE WHEN amount > 1500 THEN 2 ELSE 0 END +
        CASE WHEN channel = 'online' THEN 1 ELSE 0 END +
        CASE WHEN transactions_last_24h > 5 THEN 2 ELSE 0 END +
        CASE WHEN days_as_customer < 30 THEN 2 ELSE 0 END
    ) AS composite_risk_score
FROM transactions
WHERE (
    CASE WHEN hour >= 23 OR hour <= 2 THEN 2 ELSE 0 END +
    CASE WHEN country IN ('Nigeria','Romania','Unknown') THEN 3 ELSE 0 END +
    CASE WHEN amount > 1500 THEN 2 ELSE 0 END +
    CASE WHEN channel = 'online' THEN 1 ELSE 0 END +
    CASE WHEN transactions_last_24h > 5 THEN 2 ELSE 0 END +
    CASE WHEN days_as_customer < 30 THEN 2 ELSE 0 END
) >= 5  -- Alert threshold: tune this based on business tolerance
ORDER BY composite_risk_score DESC
LIMIT 100;


-- ── 8. Monthly trend simulation ─────────────────────────────────────────
-- Simulates what a monthly report would look like
SELECT
    (ROW_NUMBER() OVER (ORDER BY ROWID) / 4167 + 1) AS simulated_month,
    COUNT(*)                                          AS txn_count,
    SUM(is_fraud)                                     AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 2)                    AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN is_fraud=1 THEN amount END),2) AS fraud_value
FROM transactions
GROUP BY simulated_month
ORDER BY simulated_month;
