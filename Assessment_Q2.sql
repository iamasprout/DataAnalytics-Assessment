-- Step 1: Count successful transactions per user per month
WITH user_monthly_txns AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS txn_month,
        COUNT(*) AS txn_count
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'
    GROUP BY s.owner_id, txn_month
),

-- Step 2: Calculate average monthly transactions per user
user_avg_txns AS (
    SELECT
        owner_id,
        ROUND(AVG(txn_count), 2) AS avg_txn_per_month
    FROM user_monthly_txns
    GROUP BY owner_id
),

-- Step 3: Categorize each user based on their average transaction frequency
user_categories AS (
    SELECT
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM user_avg_txns
),

-- Step 4: Aggregate final counts and average per category
frequency_summary AS (
    SELECT
        frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
    FROM user_categories
    GROUP BY frequency_category
)
SELECT * FROM frequency_summary
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;