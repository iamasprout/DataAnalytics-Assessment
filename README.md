# DataAnalytics-Assessment
## Overview
This readme outlines my approach to solving the data analyst assessment questions, the challenges I encountered, and the solutions I implemented. This project contains a structured SQL analysis designed to extract meaningful insights from Cowrywise customer data. The key objectives were to evaluate user activity, categorize behavioral patterns, detect dormancy, and estimate customer value. Each question focused on a unique dimension of customer interaction and financial engagement.

#### Question 1 : High-Value Customers with Multiple Products
The business team wants to understand which users are engaged in both savings and investment products and how much they’ve deposited in total.
First aproah was to understand the table and each column i created an ER Diagram to have an overview on each table relationship.
#### Challenges:
To accurately identify actual deposits, I closely examined the confirmed_amount and transaction_status fields in the savings_savingsaccount table. I found that confirmed_amount reflects the amount of money deposited and not amount. Conversely, when confirmed_amount is greater than zero, the transaction_status is usually 'success' or 'reward'. Based on this, I determined that only transactions where confirmed_amount is greater than zero and success should be treated as valid deposits.

#### Question 2 : Transaction Frequency Analysis
To solve this, I broke the problem down into four sequential steps using Common Table Expressions (CTEs) to keep the query readable and modular:

1.Calculating Monthly Transaction Counts per User
The first CTE, user_monthly_txns, calculates how many successful transactions each user performed in each month. I filtered the dataset to include only transactions where transaction_status = 'success', focusing solely on meaningful financial activity (such as user-initiated deposits). Transactions tagged as “reward” were excluded because they don’t reflect direct user engagement in the context of deposit frequency.

Grouping was done by both user ID and the year-month value derived from the transaction date, enabling the monthly breakdown of activity.
2.Computing Average Monthly Transactions per User
Next, in user_avg_txns, I computed the average number of transactions per user per month. This metric gives a baseline for how often a user typically makes a transaction, regardless of the specific month.

3.Frequency Classification
In the third CTE, user_categories, users were assigned to frequency categories based on their average monthly activity as reqested.
These categories help distinguish heavy users from those who engage with the platform more occasionally.
Lastly, frequency_summary aggregates the total number of users in each frequency category and also calculates the average number of monthly transactions per category. The final output is ordered from the most active group (High Frequency) to the least (Low Frequency).

#### Challenges
A major consideration in this analysis was determining which types of transactions to count. Although reward transactions technically represent completed interactions, I chose to exclude them. Since the question focuses on transaction frequency as an engagement metric, it was more accurate to count only successful user-driven transactions.

### Question 3: Account Inactivity Alert
The aim of this query is to identify all savings and investment plans that have had no inflow activity for over a year, effectively flagging them as dormant or inactive.
To achieve this, I used a multi-step approach with Common Table Expressions (CTEs) to clearly organize the logic and filter criteria:
Step 1: Finding the Most Recent Cash Inflow per Plan
In the recent_inflow CTE, I filtered the savings_savingsaccount table to include only transactions with a confirmed_amount greater than zero—this ensures we only consider actual deposits, not failed or placeholder entries.
For each plan_id and its associated owner_id, I selected the latest (MAX) transaction_date, which represents the last known inflow into the plan. This tells us when each plan was last actively funded.
Step 2: Determining Last Activity and Inactivity Duration
In the plan_status CTE, I joined each plan from plans_plan with its corresponding recent inflow data from the first step.
Step 3: Isolating Dormant Plans (Inactive > 365 Days)
In the final step, I selected only those plans that had been inactive for more than one year (i.e., more than 365 days since their last deposit or creation date). 

#### Question 4: Customer Lifetime Value (CLV) Estimation
This analysis seeks to estimate the Customer Lifetime Value (CLV) of each active user based on their transaction behavior and how long they’ve been on the platform. CLV helps understand how valuable a customer is expected to be over time.
To compute CLV, I broke the problem down into a few logical stages using Common Table Expressions (CTEs) for clarity and maintainability.
Step 1: Transaction Aggregation per Customer
The customer_transactions CTE summarizes how much and how often each customer has deposited money into the platform:
Only positive confirmed transactions are considered to reflect actual value inflows.
Step 2: Calculating Customer Tenure
The customer_tenure CTE captures how long each user has been active:
Step 3: Combining Data and Computing Estimated CLV
In the clv_calc CTE, I joined the transaction and tenure data for each customer.
This formula projects the yearly value of a customer based on their transaction behavior over their current lifetime.
The results are ranked in descending order of CLV, highlighting the most valuable customers at the top.



