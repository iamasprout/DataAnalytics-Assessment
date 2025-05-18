-- Query to find users with at least one funded savings plan AND one funded investment plan,
SELECT
    u.id AS user_id,
    CONCAT(u.first_name, " ", u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN sa.id END) AS savings_count, -- Count of distinct savings transactions (from savings plans)
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN sa.id END) AS investment_count, -- Count of distinct investment transactions (from investment plans)
    ROUND(SUM(sa.confirmed_amount)) AS total_deposits
FROM savings_savingsaccount sa
inner JOIN plans_plan p ON sa.plan_id = p.id -- Join the savings account with its associated plan
inner JOIN users_customuser u ON p.owner_id = u.id -- Join the plan to the user
WHERE confirmed_amount>0 and ( p.is_a_fund = 1 OR p.is_regular_savings = 1) -- Consider only plans that are either investments or savings and having amount greater than 0
GROUP BY u.id, name -- Group by user to aggregate counts and sums per user
HAVING 
    savings_count > 0 AND investment_count > 0 -- Only include users who have both a savings and an investment plan funded
ORDER BY total_deposits DESC;

