# 🧑‍💼 SQL Staff Analysis Project

This project demonstrates how SQL can be used to perform comprehensive employee data analysis. The focus is on understanding workforce composition, salary trends, data quality, and department-wise insights within a company.

---

## 📌 What This Project Covers

The project uses raw staff data and company structure tables to perform the following:

### 🔹 1. **Descriptive Analytics**
- Count of total employees in the company
- Gender distribution across the workforce
- Number of employees in each department
- Distinct departments present
- Highest and lowest salaries across the organization

### 🔹 2. **Salary Analysis**
- Department-wise salary distribution: `MIN`, `MAX`, `AVG`, `VAR_POP`, `STDDEV_POP`
- Salary comparison by gender
- Salary spend per department and total salary expenditure
- Ranking of employees based on salary using `ROW_NUMBER()`

### 🔹 3. **Segmentation and Classification**
- Salary buckets: High, Middle, Low earners using `CASE` statements
- Role detection: Employees in "Assistant" positions using `LIKE` and `SUBSTRING`
- Identify job titles starting with specific characters or patterns

### 🔹 4. **Data Wrangling**
- Reformatting string data using `UPPER`, `LOWER`, `CONCAT`
- Numeric formatting using `ROUND`, `TRUNCATE`, `CEIL`, `FLOOR`
- Extraction of job categories and role patterns
- Cleaning and preparing department names

### 🔹 5. **Join Operations and View Creation**
- Merge staff data with company divisions and regions
- Create views (`vw_sdr`, `sdr`) to simplify analysis and reuse logic
- Identify and flag departments missing mapping in company divisions (e.g., "Books")

### 🔹 6. **Region and Division Insights**
- Number of employees per region, country, and company division
- Top 5 divisions with the highest staff count
- Full details of staff with location and division info

---

## 🧠 SQL Techniques Used

- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `HAVING`
- `JOIN`, `LEFT JOIN`, `VIEWS`
- Aggregate functions: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `VAR_POP`, `STDDEV_POP`
- String & numeric functions: `UPPER`, `LOWER`, `CONCAT`, `ROUND`, `TRUNCATE`, `SUBSTRING`, `LIKE`
- Window functions: `ROW_NUMBER()`, `OVER(PARTITION BY...)`
- CTE (`WITH`) for salary segmentation

---

## 📊 Sample Business Insights

- **Gender Split:** Balanced gender distribution across most departments.
- **Salary Spread:** The Health department shows the largest salary variation.
- **Missing Data:** 47 employees from the "Books" department are not mapped to any company division.
- **Role Classification:** Assistant roles were successfully identified and categorized using pattern recognition.
- **Top Earners:** The top 10 salary earners and highest earners in each department were extracted.

---

