# DataAnalytics-Assessment
## Overview
.......
#### Question 1 : High-Value Customers with Multiple Products
The business team wants to understand which users are engaged in both savings and investment products and how much they’ve deposited in total.
First aproah was to understand the table and each column i created an ER Diagram to have an overview on each table relationship.
#### Challenges:
To accurately identify actual deposits, I closely examined the confirmed_amount and transaction_status fields in the savings_savingsaccount table. I found that confirmed_amount reflects the amount of money deposited and not amount. Conversely, when confirmed_amount is greater than zero, the transaction_status is usually 'success' or 'reward'. Based on this, I determined that only transactions where confirmed_amount is greater than zero and success should be treated as valid deposits.
