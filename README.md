🏦 **Banking Dataset – Data Cleaning & Preparation (MySQL)**

📌 **Project Overview**

This project focuses on cleaning and preparing a real-world banking dataset containing customer demographic, credit, and payment behaviour information.

The dataset contained heavy data quality issues, including corrupted values, sentinel noise, invalid ranges, and inconsistent representations.

The primary objective was to transform raw, unreliable data into a clean, business-ready dataset suitable for analytics, dashboards, and machine learning.

This repository covers only the data cleaning phase.
________________________________________
🧩 **Dataset Description**

The dataset includes monthly customer-level banking information such as:
 
  •	Demographics (Age, Occupation, SSN)
  
  •	Financial metrics (Income, Salary, Outstanding Debt)
  
  •	Credit behavior (Loans, Credit Cards, Credit Mix)
  
  •	Payment behavior (Delayed payments, Credit inquiries, Monthly balance)

Each customer appears multiple times across months, requiring consistency-based cleaning using Customer_ID.
________________________________________
🧹 **Cleaning Actions Performed**

1️⃣ **Standardizing Missing & Corrupted Values**

Converted invalid placeholders and corrupted strings to NULL:
| Column                     | Issue Handled                          |
|----------------------------|----------------------------------------|
| Name                       | Empty → NULL                           |
| SSN                        | #F%$D@*&8 → NULL                      |
| Occupation                 | _______ → NULL                         |
| Monthly Inhand Salary      | Blank → NULL                           |
| Type of Loan               | Blank → NULL                           |
| Credit Mix                 | _ → NULL                               |
| Num Credit Inquiries       | Blank → NULL                           |
| Payment Behaviour          | !@9#%8 → NULL                          |
| Changed Credit Limit       | _ → NULL                               |
| Amount Invested Monthly    | __10000__, blank → NULL                |
| Monthly Balance            | Blank, extreme invalid strings → NULL  |
________________________________________
2️⃣ **Fixing Numeric Corruptions**

Removed formatting noise while preserving valid values:

| Column                    | Example Fix        |
|---------------------------|--------------------|
| Age                       | 24_ → 24           |
| Annual Income             | 19114_ → 19114     |
| Outstanding Debt          | 13000_ → 13000     |
| Num of Loans              | 1_ → 1             |
| Num of Delayed Payments   | 2_ → 2             |

________________________________________
3️⃣ **Range-Based Validation (Business Rules)**

Values violating realistic banking ranges were treated as invalid:

Columns validated using digit/range rules

•	Number of Bank Accounts

•	Number of Credit Cards

•	Interest Rate

•	Number of Loans

•	Number of Delayed Payments

•	Number of Credit Inquiries

👉 Values exceeding reasonable digit lengths or ranges were replaced with NULL.
________________________________________
4️⃣ **Logical Imputation Using Customer_ID**

Missing values were filled only when reliable customer-level data existed:

•	Name

•	Age

•	SSN

•	Occupation

•	Monthly Inhand Salary

•	Number of Delayed Payments

•	Changed Credit Limit

•	Number of Credit Inquiries

•	Credit Mix

•	Amount Invested Monthly

•	Monthly Balance

This ensured consistency across monthly records without introducing artificial data.
________________________________________
5️⃣ **Business Rule Enforcement**

•	When Number of Loans = 0,

→ Type_of_Loan was set to 'None'

This preserves semantic correctness instead of leaving ambiguous NULLs.
________________________________________
