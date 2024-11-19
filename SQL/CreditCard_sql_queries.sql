-- Total Customers 
SELECT 
    COUNT(Client_Num) AS 'Total_Customers'
FROM
    creditcard_detail;
    
-- Revenue 
SELECT 
    CONCAT('$ ',
            ROUND(SUM(Annual_Fees) + SUM(Interest_Earned),
                    2)) AS 'Revenue'
FROM
    creditcard_detail;

-- Average Revenue Per Customer 
SELECT 
    ROUND(SUM(Annual_Fees + Interest_Earned) / COUNT(*),
            2) AS 'AVG Customer Revenue'
FROM
    creditcard_detail;
    
-- Customer Aquisition Cost (Minimum, Average, Maximum) 
SELECT
    MIN(Customer_Acq_Cost) AS 'Min Customer_ACQ_Cost',
    ROUND(AVG(Customer_Acq_Cost), 2) AS 'AVG Customer_ACQ_Cost',
    MAX(Customer_Acq_Cost) AS 'Max Customer_ACQ_Cost'
from creditcard_detail;

-- top 3 states by most customers by Card Category 
with cte as(
SELECT 
    cd.Card_Category AS 'category',
    COUNT(cd.Client_Num) AS 'Total_Customers',
    cust.state_cd AS 'state'
FROM
    creditcard_detail AS cd
        JOIN
    customers_details AS cust ON cd.client_Num = cust.Client_Num
GROUP BY 3 , 1
ORDER BY 2 DESC),
cte1 as(
select category,
Total_Customers,
state,
rank() over(partition by category order by `Total_Customers` desc) as 'rnk' from cte)
SELECT 
    *
FROM
    cte1
WHERE
    rnk IN (1 , 2, 3);

-- Total customers by Card Category 
SELECT 
    Card_Category, COUNT(Card_Category) AS 'TotalCustomers'
FROM
    creditcard_detail
GROUP BY 1
ORDER BY 2 DESC; 

-- count of total delinquent accounts and Rate
SELECT 
    COUNT(CASE
        WHEN Delinquent_Acc = 1 THEN 1
    END) AS 'Total Delinquents',
    ROUND(COUNT(CASE
                WHEN Delinquent_Acc = 1 THEN 1
            END) / COUNT(*) * 100,
            2) AS 'Delinquency Rate'
FROM
    creditcard_detail;

-- Total Delinquent Account by Card Category 
SELECT 
    Card_Category,
    COUNT(Delinquent_Acc) AS 'Delinquent_Accounts'
FROM
    creditcard_detail
WHERE
    Delinquent_Acc = 1
GROUP BY 1;

-- avg annual fees by card category
SELECT 
    Card_Category AS 'card category',
    COUNT(Card_Category) AS 'total customers',
    round(AVG(Annual_Fees), 2) AS 'AVG fees'
FROM
    creditcard_detail
GROUP BY Card_Category
ORDER BY 3 DESC;

-- Average Utilization Ration by Card Category 
SELECT 
    Card_Category, round(AVG(Avg_Utilization_Ratio), 2) 'AVG Utilization Ratio'
FROM
    creditcard_detail
GROUP BY 1
ORDER BY 2 DESC;

-- Averages by Card Category 
SELECT 
    Card_Category as 'Card Category',
    COUNT(Client_Num) AS 'Total Customers',
    round(AVG(Customer_Acq_Cost), 2) AS 'AVG ACQ',
    round(AVG(Interest_Earned), 2) AS 'AVG Interest',
    round(AVG(Credit_Limit), 2) AS 'AVG Limit',
    round(AVG(Annual_Fees), 2) AS 'AVG Fees',
    round(AVG(Avg_Utilization_Ratio), 2) AS 'AVG Uitilization Ratio'
FROM
    creditcard_detail
GROUP BY 1;
    
-- avg age by card category 
SELECT 
    Card_Category AS 'Card_Category',
    ROUND(AVG(Customer_Age)) AS 'AVG_Age'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1;

-- total customers by Gender 
SELECT
    Gender,
    COUNT(Gender) as 'Count'
FROM
    customers_details
GROUP BY 1;

-- male female count by card category 
SELECT 
    Card_Category,
    COUNT(CASE WHEN Gender = 'M' THEN 0 END) AS 'Male_Customers',
    COUNT(CASE WHEN Gender = 'F' THEN 1 END) AS 'Female_Customers'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 
    Card_Category;

-- Gender wise Delinquent count and Rate
SELECT 
    gender AS 'Gender',
    COUNT(case when Delinquent_Acc = 1 then 1 end) AS 'Delinquent Count',
    count(case when Delinquent_Acc = 1 then 1 end) / count(*) * 100 as 'Delinquency Rate'
FROM
    customers_details AS cud
        JOIN
    creditcard_detail AS ccd ON cud.Client_Num = ccd.Client_Num
GROUP BY 1;

-- avg satisfaction score by card category 
SELECT 
    Card_Category AS 'card_category',
    AVG(Cust_Satisfaction_Score) AS 'AVG satisfaction_score'
FROM
    customers_details AS cud
        JOIN
    creditcard_detail AS ccd ON cud.Client_Num = ccd.Client_Num
GROUP BY 1
ORDER BY 2 DESC;

-- state wise and total customers, delinquent count and Rate
SELECT 
    cud.state_cd AS 'State',
    count(*) as 'Total Customers',
    COUNT(case when Delinquent_Acc = 1 then 1 end) AS 'Delinquent Count',
    round(count(case when Delinquent_Acc = 1 then 1 end) / count(*) * 100, 2) as 'Delinquent Rate'
FROM
    customers_details AS cud
        JOIN
    creditcard_detail AS ccd ON cud.Client_Num = ccd.Client_Num
GROUP BY 1
order by 2 desc;

-- state wise delinquent and revenue
SELECT 
    state_cd AS 'State',
    COUNT(ccd.Client_Num) AS 'total_customers',
    COUNT(CASE
        WHEN Delinquent_Acc = 1 THEN 1
    END) AS 'Delinquent_Count',
    round(sum(Annual_Fees) + sum(interest_earned)) as 'Revenue'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1
ORDER BY 2 DESC;

-- avg utilization ratio by states 
SELECT 
    state_cd AS 'state',
    ROUND(AVG(Avg_Utilization_Ratio), 2) AS 'AVG_Utilization'
FROM
    customers_details AS cud
        JOIN
    creditcard_detail AS ccd ON cud.Client_Num = ccd.Client_Num
GROUP BY 1
ORDER BY 2 DESC;
    
-- state wise avg satisfaction score
SELECT 
    state_cd AS 'state',
    ROUND(AVG(cust_satisfaction_score), 2) AS 'AVG_Satisfaction_Score'
FROM
    customers_details AS cud
        JOIN
    creditcard_detail AS ccd ON cud.Client_Num = ccd.Client_Num
GROUP BY 1
ORDER BY 2 DESC;
    
-- delinquent count by customer jobs
SELECT 
    cud.Customer_Job AS 'Customer Job',
    count(*) as 'Total Customers',
    COUNT(case when Delinquent_Acc = 1 then 1 end) AS 'Delinquent Count',
    round(count(case when Delinquent_Acc = 1 then 1 end) / count(*) * 100, 2) as 'Delinquent Rate'
FROM
    customers_details AS cud
        JOIN
    creditcard_detail AS ccd ON cud.Client_Num = ccd.Client_Num
GROUP BY 1
order by 2 desc;

-- delinquent_count by education level    
SELECT 
    cud.Education_Level AS 'Education Level',
    count(*) as 'Total Customers',
    COUNT(case when Delinquent_Acc = 1 then 1 end) AS 'Delinquent Count',
    round(count(case when Delinquent_Acc = 1 then 1 end) / count(*) * 100, 2) as 'Delinquent Rate'
FROM
    customers_details AS cud
        JOIN
    creditcard_detail AS ccd ON cud.Client_Num = ccd.Client_Num
GROUP BY 1
order by 2 desc;

-- Averages by State 
SELECT 
    state_cd,
    ROUND(AVG(Customer_Acq_Cost)) AS 'AVG Customer ACQ',
    ROUND(AVG(Annual_Fees)) as 'AVG Annual Fees',
    ROUND(AVG(Interest_Earned)) as 'AVG Interest Earned'
FROM
    customers_details AS cud
        JOIN
    creditcard_detail AS ccd ON cud.Client_Num = ccd.Client_Num
GROUP BY 1
ORDER BY 2 DESC;
    
-- avg trans amt 
SELECT 
    ROUND(AVG(Total_Trans_Amt)) AS 'avg transaction amount'
FROM
    creditcard_detail;

-- avg trans amt by card category
SELECT 
    Card_Category,
    ROUND(AVG(Total_Trans_Amt)) AS 'avg transaction amount'
FROM
    creditcard_detail
GROUP BY 1
ORDER BY 2 DESC;
    
-- top 10 client by total trans amt 
with cte as (    
SELECT 
    Client_Num, Card_Category, Total_Trans_Amt
FROM
    creditcard_detail
ORDER BY 3 DESC),
cte1 as (
select *, rank() over(order by Total_Trans_Amt desc) as rnk from cte)
SELECT 
    *
FROM
    cte1
WHERE
    rnk BETWEEN 1 AND 10;
    
-- total (customers, trans amt, interest earned) by use chip 
SELECT 
    `Use Chip`,
    COUNT(`Use Chip`) AS 'Use Count',
    SUM(Total_Trans_Amt) as 'Total Trans AMT',
    round(sum(Interest_Earned), 2) AS 'Total Interest'
FROM
    creditcard_detail
GROUP BY 1;

-- card uses by expense type 
SELECT 
    `Exp Type`, COUNT(Client_Num) AS 'Card_Use'
FROM
    creditcard_detail
GROUP BY 1
ORDER BY 2 DESC;
   
-- Gender wise total customers and AVG(annual fees, interest earned, acquisation cost, utilization ratio) 
SELECT 
    Gender,
    COUNT(CASE
        WHEN Gender = 'M' THEN 1
        ELSE 0
    END) AS 'total_customers',
    ROUND(AVG(CASE
                WHEN Gender = 'M' THEN Annual_Fees
                ELSE Annual_Fees
            END)) AS 'AVG_annual_fees',
    ROUND(AVG(CASE
                WHEN Gender = 'M' THEN Interest_Earned
                ELSE Interest_Earned
            END)) AS 'AVG_interest_earned',
    ROUND(AVG(CASE
                WHEN Gender = 'M' THEN Customer_Acq_Cost
                ELSE Customer_Acq_Cost
            END)) AS 'AVG_ACQ_cost',
    CAST(AVG(CASE
            WHEN Gender = 'M' THEN Avg_Utilization_Ratio
            ELSE Avg_Utilization_Ratio
        END)
        AS DECIMAL (3 , 2 )) 'AVG_utili_ratio'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num GROUP BY 1;
    
-- Total customers card activated before 30 days 
SELECT 
    COUNT(Activation_30_Days) AS 'Count'
FROM
    creditcard_detail
WHERE
    Activation_30_Days = 1;

-- Credit Card activated before 30 days by card category 
with cte as (
SELECT
    Card_Category,
    COUNT(Client_Num) as 'total_customers',
    COUNT(CASE
        WHEN Activation_30_Days = 1 THEN 1
    END) AS 'activate_30_days'
FROM
    creditcard_detail
GROUP BY 1)
SELECT 
    Card_Category,
    total_customers,
    activate_30_days,
    CONCAT(ROUND((activate_30_days / total_customers) * 100, 2),
            ' %') AS 'percent'
FROM
    cte;

-- delinquent count by marital status 
SELECT 
    Marital_Status,
    COUNT(Marital_Status) AS 'total_customers',
    COUNT(CASE
        WHEN Delinquent_Acc = 1 THEN 1
    END) AS 'delinquent_acc'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1;

-- Delinquent acount by Personal Loan  
SELECT 
    Personal_loan,
    COUNT(Personal_loan) AS 'total_customers',
    COUNT(CASE
        WHEN Delinquent_Acc = 1 THEN 1
    END) AS 'delinquent_acc'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1;

-- Customer count by Income Group
SELECT 
    CASE
        WHEN income BETWEEN 1250 AND 25000 THEN 'Low Income'
        WHEN income BETWEEN 25001 AND 50000 THEN 'Mid Income'
        WHEN income BETWEEN 50001 AND 75000 THEN 'High Income'
        ELSE 'Very High'
    END AS 'Income_Group',
    COUNT(Income) AS 'Customer Count'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1
ORDER BY 2 DESC;

-- Average Income 
SELECT 
    round(avg(Income), 2) as 'AVG Income'
FROM
    customers_details;

-- Income (Minimum, Average, Maximum) 
SELECT 
    MIN(Income) AS 'Min Income',
    ROUND(AVG(Income), 2) AS 'AVG Income',
    MAX(Income) AS 'Max Income'
FROM
    customers_details;

-- Week on Week Revenue Change 
with cte as (
SELECT 
    WEEK(STR_TO_DATE(week_start_date, '%d-%m-%Y')) AS 'Week_No',
    ROUND(SUM(Annual_Fees) + SUM(Interest_Earned)) AS 'Revenue'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1
ORDER BY 1),
cte1 as (
select *, coalesce(lag(Revenue) over(), 0) as 'Previous_Week' from cte)
SELECT
    week_no,
    revenue,
    COALESCE(CONCAT(ROUND(((revenue - previous_week) / previous_week) * 100),
                    '%'),
            0) AS 'WoW_change'
FROM
    cte1;

-- Running Total by Week no 
with cte as (
SELECT 
    WEEK(STR_TO_DATE(week_start_date, '%d-%m-%Y')) AS 'Week_No',
    ROUND(SUM(Annual_Fees) + SUM(Interest_Earned)) AS 'Revenue'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1
ORDER BY 1)
SELECT 
    week_no,
    sum(revenue) over(order by week_no) AS 'Cumulative_Revenue'
FROM
    cte group by 1;

-- Revenue Moving Averages for 4 Weeks 
with cte as (
SELECT 
    WEEK(STR_TO_DATE(week_start_date, '%d-%m-%Y')) AS 'Week_No',
    ROUND(SUM(Annual_Fees) + SUM(Interest_Earned)) AS 'Revenue'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1
ORDER BY 1)
select week_no,
round(avg(revenue)
over(order by week_no rows between 3 preceding and current row))
as Moving_AVG
from
	cte;

-- Interest Earned Moving Averages for 4 Weeks
with cte as (
SELECT 
    WEEK(STR_TO_DATE(week_start_date, '%d-%m-%Y')) AS 'Week_No',
    ROUND(SUM(Interest_Earned), 2) AS 'Interest'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1
ORDER BY 1)
select *, round(avg(interest) over(order by week_no rows between 3 preceding and current row)) as Moving_AVG from cte;

-- total annual fees and interest earned 
select sum(Annual_Fees) as 'total fees', round(sum(Interest_Earned)) as 'total interest earned' from creditcard_detail;

-- total annual fees and interest earned by card category  
SELECT 
    Card_Category,
    SUM(Annual_Fees) AS total_fees,
    ROUND(SUM(Interest_Earned)) AS total_interest_earned
FROM
    creditcard_detail
GROUP BY 1;

-- create Age Group temporary table
create temporary table Temp_Age_Group (
SELECT 
    *,
    CASE
        WHEN Customer_Age BETWEEN 21 AND 35 THEN '21-35'
        WHEN Customer_Age BETWEEN 36 AND 49 THEN '36-49'
        WHEN Customer_Age BETWEEN 50 AND 60 THEN '50-60'
        ELSE '60+'
    END AS 'age_group'
FROM
    customers_details
);

-- create temporary table for Revenue 
create temporary table temp_revenue (  
SELECT 
    *, ROUND(Annual_Fees + interest_earned, 2) AS 'Revenue'
FROM
    creditcard_detail );

-- Revenue by Age Group 
SELECT 
    age_group,
    COUNT(revenue) AS 'total_customers',
    ROUND(SUM(revenue), 2) AS 'Revenue'
FROM
    temp_revenue AS tr
        JOIN
    temp_age_group AS tag ON tr.Client_Num = tag.client_num
GROUP BY 1
ORDER BY 2 DESC;

-- delinquent count by age group 
with cte as(
SELECT 
    tage.age_group AS 'age_group',
    COUNT(trev.delinquent_acc) AS 'total_customers',
    count(case
    when trev.delinquent_acc = 1 then 1 end) as 'total_delinquent'
FROM
    temp_age_group AS tage
        JOIN
    temp_revenue AS trev ON trev.Client_Num = tage.client_num
GROUP BY 1)
select *,
concat(round(total_delinquent/total_customers*100, 2), '%') as '%_of_total' from cte;

-- avg annual fees by state compared to whole avg annual fees
with cte as (
SELECT 
    state_cd AS 'State',
    COUNT(*) AS 'Total Customers',
    ROUND(AVG(Annual_Fees)) AS 'AVG Fees State',
    ROUND((SELECT 
                    AVG(Annual_Fees)
                FROM
                    creditcard_detail)) AS 'AVG Annual Fees'
FROM
    creditcard_detail AS ccd
        JOIN
    customers_details AS cud ON ccd.Client_Num = cud.Client_Num
GROUP BY 1)
SELECT 
    *, concat('$ ', (`AVG Fees State` - `AVG Annual Fees`)) AS 'Diff'
FROM
    cte;
    
-- create stored procedure to search Credit Card details
DELIMITER $$    
CREATE PROCEDURE credit_details(IN client_n TEXT)
BEGIN
    SET @sql_query = CONCAT('
        SELECT 
            ccd.Client_Num,
            ccd.Card_Category,
            ccd.Total_Trans_Amt,
            ccd.Annual_Fees,
            ccd.Credit_limit,
            cud.Customer_Age,
            cud.Gender,
            cud.Income,
            cud.state_cd
        FROM creditcard_detail AS ccd
        JOIN customers_details AS cud ON ccd.Client_Num = cud.Client_Num
        WHERE ccd.Client_Num IN (', client_n, ')');
        
    -- Execute the dynamically constructed query
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

-- call the procedure with integer IDs
CALL credit_details('708082083, 708083283, 708084558');

-- drop stored procedure 
drop procedure if exists credit_details;

-- Count Customers who have less Average Utilization Ration than Average Ratio
select count(*) as Customer_count from creditcard_detail where Avg_Utilization_Ratio < (
select avg(Avg_Utilization_Ratio) from creditcard_detail);

-- Average Utilization Ratio and Average Credit Limit by Age Group 
SELECT 
    CASE 
        WHEN Customer_Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Customer_Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Customer_Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Customer_Age BETWEEN 46 AND 60 THEN '46-60'
        WHEN Customer_Age > 60 THEN '60+'
        ELSE 'Unknown'
    END AS Age_Group,
    round(AVG(Avg_Utilization_Ratio), 3) AS avg_utilization_ratio,
    round(AVG(Credit_Limit), 2) AS avg_credit_limit
FROM creditcard_detail ccd
JOIN customers_details cud ON ccd.Client_Num = cud.Client_Num
GROUP BY Age_Group
ORDER BY Age_Group;

-- Group on Profitable, Break-even, Unprofitable and Count Total Customers 
with cte as (SELECT 
    ccd.Client_Num,
    ccd.Annual_Fees,
    ccd.Customer_Acq_Cost,
    CASE
        WHEN ccd.Annual_Fees > ccd.Customer_Acq_Cost THEN 'Profitable'
        WHEN ccd.Annual_Fees = ccd.Customer_Acq_Cost THEN 'Break-even'
        ELSE 'Unprofitable'
    END AS Profitability_Status
FROM creditcard_detail AS ccd
WHERE ccd.Customer_Acq_Cost IS NOT NULL
ORDER BY Profitability_Status DESC, Annual_Fees DESC) 
SELECT 
    Profitability_Status, COUNT(*) AS Total
FROM
    cte
GROUP BY Profitability_Status;

-- Monthly Revenue and Month on Month Change 
with cte as (
SELECT 
    MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) AS 'Months',
    ROUND(SUM(Annual_Fees + Interest_Earned), 2) AS 'Revenue'
FROM
    creditcard_detail
GROUP BY 1),
cte1 as (
select *, lag(revenue) over() as 'pre_rev' from cte)
SELECT 
    months,
    revenue,
    CONCAT(ROUND(COALESCE((revenue - pre_rev) / revenue * 100, 0),
                    2),
            '%') AS 'MoM Change'
FROM
    cte1;
    
-- Three Month Simple Moving Average 
with cte as
(SELECT 
    MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) as 'Months',
    ROUND(SUM(Annual_Fees + Interest_Earned)) as 'Revenue'
FROM
    creditcard_detail
GROUP BY 1 )
select Months,
round((sum(revenue) over(rows between 2 preceding and current row)) / 3, 2)
as 'Moving AVG'
from
cte;

-- Quarterly Cumulative Sum
with cte as (
SELECT 
    CONCAT('Q',
            QUARTER(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y'))) AS 'Quarters',
    ROUND(SUM(Annual_Fees + Interest_Earned), 2) AS 'Revenue'
FROM
    creditcard_detail
GROUP BY 1)
select *,
sum(revenue) over(order by quarters) as 'Cumulative Sum'
from
	cte;

-- Quarterly Cumulative Sum using Sub-query 
SELECT 
    Year,
    Quarter,
    Revenue,
    ROUND(SUM(Revenue) OVER (
        PARTITION BY Year
        ORDER BY Quarter
    ), 2) AS Cumulative_Revenue
FROM (
    SELECT 
        YEAR(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) AS Year,
        CONCAT('Q', QUARTER(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y'))) AS Quarter,
        ROUND(SUM(Annual_Fees + Interest_Earned), 2) AS Revenue
    FROM 
        creditcard_detail
    GROUP BY 
        Year, Quarter
) AS aggregated_data
ORDER BY 
    Year, Quarter;

-- Quarter on Quarter Change % 
with cte as (
SELECT 
    CONCAT('Q',
            QUARTER(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y'))) AS Quarter,
            ROUND(SUM(Annual_Fees + Interest_Earned), 2) AS Revenue
FROM
    creditcard_detail group by quarter),
cte1 as(
select *, coalesce(lag(Revenue) over(), 0) as 'pre_rev' from cte),
cte2 as(
SELECT 
    quarter,
    revenue,
    CONCAT(COALESCE(ROUND((revenue - pre_rev) / pre_rev * 100, 2),
                    0),
            '%') AS 'QoQ Change'
FROM
    cte1)
select * from cte2;

-- Profitability Analysis (e.g., Profit Margin)
SELECT 
    CONCAT('Q',
            QUARTER(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y'))) AS Quarter,
    YEAR(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) AS Year,
    ROUND(SUM(Annual_Fees + Interest_Earned), 2) AS Revenue,
    ROUND(SUM(Customer_Acq_Cost), 2) AS Total_Cost,
    ROUND(SUM(Annual_Fees + Interest_Earned) - SUM(Customer_Acq_Cost),
            2) AS Profit,
    ROUND(((SUM(Annual_Fees + Interest_Earned) - SUM(Customer_Acq_Cost)) / SUM(Annual_Fees + Interest_Earned)) * 100,
            2) AS Profit_Margin_Percentage
FROM
    creditcard_detail
GROUP BY Year , Quarter
ORDER BY Year , Quarter;

-- Gender wise Monthly Revenue
SELECT 
    cud.Gender,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'January' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS January,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'February' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS February,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'March' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS March,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'April' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS April,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'May' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS May,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'June' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS June,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'July' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS July,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'August' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS August,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'September' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS September,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'October' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS October,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'November' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS November,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'December' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS December
FROM
    creditcard_detail as ccd join customers_details as cud on ccd.Client_Num=cud.Client_Num
GROUP BY
    cud.Gender;
    
-- create view for- Monthly Revenue by Card Category
create view Monthly_Revenue as  
SELECT 
    Card_Category,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'January' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS January,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'February' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS February,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'March' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS March,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'April' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS April,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'May' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS May,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'June' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS June,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'July' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS July,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'August' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS August,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'September' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS September,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'October' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS October,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'November' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS November,
    ROUND(SUM(CASE WHEN MONTHNAME(STR_TO_DATE(Week_Start_Date, '%d-%m-%Y')) = 'December' THEN Annual_Fees + Interest_Earned ELSE 0 END), 2) AS December
FROM
    creditcard_detail
GROUP BY
    Card_Category;
-- use view 
select * from monthly_revenue;
    
-- Above Average Acquisition Cost by Card Category
SELECT 
    Card_Category 'Card Category',
    AVG(Customer_Acq_Cost) AS 'AVG ACQ'
FROM
    creditcard_detail
GROUP BY 1
HAVING AVG(Customer_Acq_Cost) > (SELECT 
        AVG(Customer_Acq_Cost)
    FROM
        creditcard_detail);
        
-- Above Average Acquisition Cost by Card Category using Sub-Query
SELECT 
    Card_Category AS 'Card Category',
    AVG(Customer_Acq_Cost) AS 'AVG ACQ',
    (SELECT 
            AVG(Customer_Acq_Cost)
        FROM
            creditcard_detail) AS 'Overall AVG ACQ'
FROM
    creditcard_detail
GROUP BY Card_Category
HAVING AVG(Customer_Acq_Cost) > (SELECT 
        AVG(Customer_Acq_Cost)
    FROM
        creditcard_detail);

-- Comparison of Average Transaction Amounts for 'Blue' Card Category with Chip for 'Online' Transactions
SELECT 
    `Exp Type`,
    ROUND(AVG(Total_Trans_Amt), 2) AS 'AVG Amt Exp Type',
    (SELECT 
            ROUND(AVG(Total_Trans_Amt), 2)
        FROM
            creditcard_detail
        WHERE
            Card_Category LIKE 'blue%'
                AND `use chip` LIKE 'online%') AS 'AVG Trans Amt Condition',
    (SELECT 
            ROUND(AVG(Total_Trans_Amt), 2)
        FROM
            creditcard_detail) AS 'AVG Trans Amt Overall'
FROM
    creditcard_detail
WHERE
    `Use Chip` LIKE 'Online%'
        AND Card_Category LIKE 'blue%'
GROUP BY 1
HAVING AVG(Total_Trans_Amt) > `AVG Trans Amt Condition`
ORDER BY 2 DESC;

-- Comparison of Average Transaction Amounts for 'Blue' Card Category with Chip for 'Online' Transactions, using CTEs
with cte1 as (
SELECT 
    `Exp Type` as 'Exp Type', round(AVG(Total_Trans_Amt), 2) AS 'AVG Amt Exp Type'
FROM
    creditcard_detail
WHERE
    `Use Chip` LIKE 'online%'
        AND Card_Category LIKE 'blue%'
GROUP BY 1),
cte2 as (
select round(AVG(Total_Trans_Amt), 2) AS 'AVG Trans Amt Condition'
FROM
    creditcard_detail
WHERE
    `Use Chip` LIKE 'online%'
        AND Card_Category LIKE 'blue%'),
cte3 as (    
SELECT 
    round(AVG(Total_Trans_Amt), 2) AS 'AVG Trans Amt Overall'
FROM
    creditcard_detail)
SELECT 
    `Exp Type`, `AVG Amt Exp Type`, `AVG Trans Amt Condition`, `AVG Trans Amt Overall`
FROM
    cte1
        JOIN
    cte2
        JOIN
    cte3
HAVING `AVG Amt Exp Type` > `AVG Trans Amt Condition`
ORDER BY 2 DESC;

-- Top 5 Most Positive and Negative Weeks by Revenue 
with cte1 as (
SELECT 
    WEEK(STR_TO_DATE(week_start_date, '%d-%m-%Y')) AS 'Week_No',
    ROUND(SUM(Annual_Fees) + SUM(Interest_Earned)) AS 'Revenue',
    coalesce(lag(ROUND(SUM(Annual_Fees) + SUM(Interest_Earned)))
    over(order by WEEK(STR_TO_DATE(week_start_date, '%d-%m-%Y'))),
    0) as 'Pre_rev'
FROM
    creditcard_detail
GROUP BY 1),
cte2 as(
SELECT 
    *,
    COALESCE(CONCAT(ROUND((((revenue - pre_rev) / pre_rev) * 100),
                            2),
                    '%'),
            0) AS 'WoW_Change', rank()
            over(order by round((((revenue - pre_rev) / pre_rev) * 100), 2))
as 'rnk'
from cte1)
SELECT 
    Week_No, Revenue, WoW_Change
FROM
    cte2
WHERE
    rnk BETWEEN 48 AND 52
        OR rnk BETWEEN 2 AND 6
ORDER BY 3 DESC;
