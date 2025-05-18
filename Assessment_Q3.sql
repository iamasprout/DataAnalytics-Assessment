-- Step 1: Identify the most recent inflow transaction for each plan
WITH recent_inflow AS (
    SELECT 
        plan_id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE 
        confirmed_amount > 0  
        AND transaction_date IS NOT NULL
    GROUP BY plan_id, owner_id
),

-- Step 2: Join recent inflows to plans and calculate inactivity duration
plan_status AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        -- Classify plan type
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Unknown'
        END AS type,
        -- Use recent transaction date or get plan creation date if null
        COALESCE(r.last_transaction_date, p.created_on) AS last_transaction_date,
        -- Calculate number of days since last activity
        DATEDIFF(CURRENT_DATE, COALESCE(r.last_transaction_date, p.created_on)) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN recent_inflow r ON p.id = r.plan_id
    WHERE 
        -- Only include savings or investment plans
        (p.is_regular_savings = 1 OR p.is_a_fund = 1)
        -- Exclude archived or deleted plans
        AND p.is_archived = 0
        AND p.is_deleted = 0
)

-- Step 3: Select plans inactive for more than a year
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM plan_status
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;
