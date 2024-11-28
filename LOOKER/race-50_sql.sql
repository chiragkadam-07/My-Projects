-- how many states represented in the race
SELECT 
    COUNT(DISTINCT state) AS Total_States
FROM
    race_csv;

-- what was the avereage time of men vs women
SELECT 
    Gender, AVG(Minutes)
FROM
    race_csv
GROUP BY Gender;

-- what were the youngest and oldest ages in race
SELECT 
    Gender,
    MIN(Age) AS 'Youngest person Age',
    MAX(Age) AS 'Oldest person Age'
FROM
    race_csv
GROUP BY Gender;

-- what was the average time for each age group
select avg(Minutes) as AVG_Min,
case
	when Age > 20 and Age < 30 then '20-29'
	when Age >= 30 and Age < 40 then '30-39'
	when Age >= 40 and Age < 50 then '40-49'
	when Age >= 50 and Age < 60 then '50-59'
	else '60+'
end as 'Age_Group'
from race_csv group by `Age_Group` order by 2;

-- with cte 
with age as(
select Minutes,
case 
	when Age < 30 then '20-29'
	when Age < 40 then '30-39'
	when Age < 50 then '40-49'
	when Age < 60 then '50-59'
	else '60+' 
end as 'Age_Group'
from race_csv)
select Age_Group, avg(Minutes) as AVG_Min from  age group by Age_Group order by 1;

-- Rank Age Groups by Average Time 
with cte as(
select avg(Minutes) as 'Average_Time',
case
	when Age > 20 and Age < 30 then '20-29'
	when Age > 30 and Age < 40 then '30-39'
	when Age > 40 and Age < 50 then '40-49'
	when Age > 50 and Age < 60 then '50-59'
	else '60+'
end as 'Age_Group'
from race_csv group by `Age_Group` order by 2)
select Age_Group, Average_Time, rank() over(order by Average_Time) as rnk from cte;

-- Top 3 Age Groups by Average Time
with cte as(
select avg(Minutes) as 'Average_Time',
case
	when Age > 20 and Age < 30 then '20-29'
	when Age > 30 and Age < 40 then '30-39'
	when Age > 40 and Age < 50 then '40-49'
	when Age > 50 and Age < 60 then '50-59'
	else '60+'
end as 'Age_Group'
from race_csv group by `Age_Group` order by 2),
cte1 as(
select *, rank() over(order by Average_Time) as rnk from cte)
(SELECT 
    Age_Group, Average_Time
FROM
    cte1
WHERE
    rnk IN (1 , 2, 3));

-- Top 3 males and females in Race
with cte as(
SELECT Name, Gender, Minutes, row_number() over(partition by Gender order by Minutes) as rnk
from race_csv)
SELECT 
    *
FROM
    cte
WHERE
    rnk IN (1 , 2, 3)
ORDER BY Gender DESC;

-- Bottom 3 in the Race by gender 
with cte as(
SELECT Name, Gender, Minutes, row_number() over(partition by Gender order by Minutes desc) as rnk
from race_csv)
SELECT 
    *
FROM
    cte
WHERE
    rnk IN (1 , 2, 3);

-- Create a view for top 3 males and females
create view Top_3 as
with cte as(
SELECT Name, Gender, Minutes, row_number() over(partition by Gender order by Minutes) as rnk
from race_csv)
SELECT 
    *
FROM
    cte
WHERE
    rnk IN (1 , 2, 3)
ORDER BY Gender DESC;

-- Use the view 
SELECT 
    *
FROM
    top_3;

-- Drop the view 
drop view top_3;
