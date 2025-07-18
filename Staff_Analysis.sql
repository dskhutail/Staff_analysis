USE project;

select * from company_divisions;

select * from company_divisions;

select * from staff;


/************ Basic Statistics with SQL ************/


-- How many total employees in the company? 

select count(*)
from staff;

-- What about gender distribution?

select gender, count(*) as Total_employees
from staff
group by gender
order by gender;

-- How many employees in each department?

select department, count(*) as Total_employee
from staff
group by department
order by department;

-- How many distinct department?

select count(*)
from (select distinct department
from staff
order by department) t;  

-- What is the highrst and the lowest salary of employee?

select max(salary) as max_salary, min(salary) as min_salary
from staff;

-- What about salary distribution by gender?

select gender, round(avg(salary),2) as avg_salaray, max(salary) as max_salary, min(salary) as min_salary
from staff
group by gender;

-- How much total salary company is spending each yea?

select department, department_expense,
Sum(department_expense) over () as total_salary_expense
from 
(select department, sum(salary) as department_expense
from staff
group by department) as t;

-- Distribution of min, max, avg salary by department

select department,
min(salary) as min_salary,
max(salary) as max_salary,
ceil(avg(salary)) as avg_salary,
count(*) as Total_employees
from staff
group by department
order by department;

-- how spread out those salary around the average salary in each department ?

select department,
min(salary) as min_salary,
max(salary) as max_salary,
ceil(avg(salary)) as avg_salary,
floor(var_pop(salary)) as var_salary,
floor(stddev_pop(salary)) as sd_salary,
count(*) as Total_employees
from staff
group by department
order by 4 desc;

-- which department has the highest salary spread out ?

select department,
min(salary) as min_salary,
max(salary) as max_salary,
ceil(avg(salary)) as avg_salary,
floor(var_pop(salary)) as var_salary,
floor(stddev_pop(salary)) as sd_salary,
count(*) as Total_employees
from staff
group by department
order by 6 desc;

-- Let's see Health department salary

select department,
min(salary) as min_salary,
max(salary) as max_salary,
ceil(avg(salary)) as avg_salary,
floor(var_pop(salary)) as var_salary,
floor(stddev_pop(salary)) as sd_salary,
count(*) as Total_employees
from staff
group by department
having department = "Health";

-- we will make 3 buckets to see the salary earning status for Health Department

with earning_table as
(select *, 
case
when salary > 100000 then "High_earner"
when salary between 50000 and 100000 then "Middle_earner"
else "Low_earner"
end as Type_of_earning
from staff)

select department, type_of_earning, count(*) as Total_employee 
from earning_table
group by department, type_of_earning
order by department, type_of_earning;

-- What are the deparment start with B

select distinct  department
from staff
where department like "B%";



/**************** Data Wrangling / Data Munging *************/



select distinct department
from staff
order by department;

-- Reformatting Characters Data

select distinct upper(department) as department
from staff
order by 1;

select distinct lower(department) as department
from staff
order by 1;

-- Concatenation

select last_name,
concat(job_title, " - " ,department) as title_with_department
from staff
order by 1;

-- How many employees with Assistant roles

select count(*) as assistant_roles
from staff
where job_title like "%assistant%";

-- What are those Assistant roles?

select distinct job_title
from staff
where job_title like "%assistant%"
order  by 1;

-- let's check which roles are assistant role or not

select distinct job_title,
job_title like "%assistant%" as assistant_role
from staff
order by 1;

-- We want to extract job category from the assistant position which starts with word Assisant

select job_title,
substring(job_title,length("assistant")+1) as job_category
from staff
where job_title like "assistant%";

/* now we want to know job title with Assistant, started with roman numerial I, follwed by 1 character
it can be II,IV, etc.. as long as it starts with character I 

underscore _ : for one character */

select distinct job_title
from staff
where job_title like "%assistant I_"
order by 1;

-- job title starts with either E, P or S character , followed by any characters

select distinct job_title
from staff
where job_title like "E%" or
job_title like "P%" or 
job_title like "S%"
order by 1;

/********* Reformatting Numerics Data *********/
-- TRUNC() Truncate values Note: trunc just truncate value, not rounding value.
-- CEIL
-- FLOOR
-- ROUND

select department, 
avg(salary) as avg_salary,
truncate(avg(salary),0) as truncated_salary,
truncate(avg(salary),2) as truncated_salary_2decimal,
round(avg(salary),2) as round_salary,
floor(avg(salary)) as floor_salary,
ceil(avg(salary)) as ceil_salary
from staff
group by department
order by 1;



/********** Filterig, Join and Aggregration ************/



-- we want to know person's salary comparing to his/her department average salary

select last_name, department, salary,
round(avg(salary) over(partition by department order by department),2) as avg_salary 
from staff
order by last_name;

-- how many people are earning above/below the average salary of his/her department ?

select count(*)
from (
select department,salary, 
round(avg(salary) over (partition by department),2) as dept_salary
from staff) as t
where salary >dept_salary;

/* Assume that people who earn at latest 100,000 salary is Executive.
We want to know the average salary for executives for each department.*/


select department, round(avg(salary),2) as avg_salary
from staff
where salary > 100000
group by department
order by 1;

-- who earn the most in the company?

select department, last_name, salary
from staff
where salary = (select max(salary)
				from staff);
                
                
-- who earn the most in his/her own department

select department, last_name, salary
from (
select *,
row_number() over (partition by department order by salary desc) as rw
from staff) as t
where rw < 2 ;

/* full details info of employees with company division
Based on the results, we see that there are only 953 rows returns. We know that there are 1000 staffs.
*/

select *
from company_divisions;

select * 
from staff s
join company_divisions cd
on s.department = cd.department;

/* now all 1000 staffs are returned, but some 47 people have missing company - division.*/

select *
from staff s
left join company_divisions cd
on s.department = cd.department;

/* who are those people with missing company division? 
Data Interpretation: it seems like all staffs from "books" department have missing company division.
We may want to inform our IT team to add Books department in corresponding company division.
*/

select *
from staff s
left join company_divisions cd
on s.department = cd.department
where cd.company_division is null;

create view vw_sdr as
select s.*, d.company_division,r.company_regions
from staff s
left join company_regions r
on s.region_id = r.region_id
left join company_divisions d
on s.department = d.department;

select * from vw_sdr;

select count(*)
from vw_sdr;

-- How many staffs are in each company regions?

select company_regions, count(*) as Total_staff
from vw_sdr
group by Company_regions
order by 1;

-- How many staffs are in each company regions and department?

select company_regions, department, count(*) as Total_staff
from vw_sdr
group by 1,2
order by 1,2;

create view sdr as
select s.*, d.company_division, r.company_regions, r.country
from staff s
left join company_divisions d
on s.department = d.department
left join company_regions r
on s.region_id = r.region_id;

select * from sdr;

-- employees per regions and country

select country, company_regions, count(*)
from sdr
group by 1,2
order by 1,2;

-- What are the top salary earners ?

select *
from (
select last_name, salary,
row_number() over(order by salary desc) as sn
from staff) t
where sn < 11;


-- Top 5 division with highest number of employees

select company_division, count(*) as te
from sdr
group by 1
order by 2 desc
limit 5;

