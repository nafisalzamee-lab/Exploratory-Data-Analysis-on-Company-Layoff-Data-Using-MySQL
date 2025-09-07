### ** Exploratory Data Analysis on Layoffs Dataset with SQL**
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![SQL Database](https://img.shields.io/badge/SQL%20Database-2E8B57?style=for-the-badge&logo=azuredevops&logoColor=white)

[![YouTube](https://img.shields.io/badge/Watch%20on-YouTube-red?logo=youtube)](https://youtu.be/X4ee_lMhEmU)
[![Connect with me on LinkedIn](https://img.shields.io/badge/Connect%20with%20me-LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/md-nafis-al-zamee-a88a9024b)

---

📊 **Project Overview:**  
This project involves an extensive Exploratory Data Analysis (EDA) on a layoffs dataset covering global companies from 2020 to early 2023. Using clean data prepared from a prior cleaning project, the objective was to uncover meaningful trends and insights on layoffs by company, industry, country, and over time. The analysis was iterative and exploratory, starting simple and progressing to advanced SQL techniques such as window functions and multi-step Common Table Expressions (CTEs).

---

🛠️ **Technologies and Skills Demonstrated:**  
- Advanced SQL querying (GROUP BY, ORDER BY, window functions, CTEs)  
- Data exploration and aggregation  
- Time series analysis with substring and date functions  
- Ranking and partitioning datasets with DENSE_RANK()  
- Data cleaning integration and handling incomplete data  
- Iterative exploratory analysis mindset  

---

🗂️ **Data Set Details:**  
- Company names  
- Total layoffs and percentage layoffs per event  
- Industry sector  
- Country  
- Funding raised (in millions)  
- Company stage (seed, series rounds, IPO, etc.)  
- Layoff event dates  

---

🛠️🧩 **Key Processes Performed:**

1. **Initial Data Exploration and Maximum Layoffs Check:**  
The analysis began by inspecting the maximum layoffs reported on any single day and identifying companies with total workforce layoffs (100%). This provided context on scale and severity.  

```sql
SELECT MAX(total_laid_off) FROM layoffs;
SELECT MAX(percentage_laid_off) FROM layoffs;
SELECT * FROM layoffs WHERE percentage_laid_off = 1;
```

2. **Sorting Companies by Largest Layoffs:**  
To identify which companies had the largest single layoffs, data was ordered descending by total layoffs.  

```sql
SELECT * FROM layoffs ORDER BY total_laid_off DESC;
```

3. **Summing Total Layoffs by Company:**  
Grouping layoffs by company to get cumulative layoffs over the data period.  

```sql
SELECT company, SUM(total_laid_off) AS total_laid_off_sum 
FROM layoffs 
GROUP BY company 
ORDER BY total_laid_off_sum DESC;
```

4. **Checking Date Range of Dataset:**  
Determined the temporal span of the dataset to understand coverage.  

```sql
SELECT MIN(date), MAX(date) FROM layoffs;
```

5. **Industry-wise Layoffs Aggregation:**  
Summed total layoffs by industry to spot hardest hit sectors.  

```sql
SELECT industry, SUM(total_laid_off) AS total_laid_off_sum 
FROM layoffs 
GROUP BY industry 
ORDER BY total_laid_off_sum DESC;
```

6. **Country-wise Layoffs Aggregation:**  
Identified countries with most layoffs.  

```sql
SELECT country, SUM(total_laid_off) AS total_laid_off_sum 
FROM layoffs 
GROUP BY country 
ORDER BY total_laid_off_sum DESC;
```

7. **Yearly Layoffs Aggregation:**  
Extracted year from date and grouped layoffs by year to observe trends over time.  

```sql
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off_sum 
FROM layoffs 
GROUP BY year 
ORDER BY year;
```

8. **Stage-wise Layoffs Analysis:**  
Grouped layoffs by company funding stage to analyze impact across company maturity levels.  

```sql
SELECT stage, SUM(total_laid_off) AS total_laid_off_sum 
FROM layoffs 
GROUP BY stage 
ORDER BY total_laid_off_sum DESC;
```

9. **Rolling Total Layoffs by Month:**  
Calculated rolling cumulative layoffs month by month using substring extraction of year and month from the date, then applying window functions.  

```sql
WITH monthly_layoffs AS (
  SELECT 
    SUBSTRING(date, 1, 7) AS year_month,
    SUM(total_laid_off) AS total_laid_off_sum
  FROM layoffs
  GROUP BY year_month
)
SELECT 
  year_month,
  total_laid_off_sum,
  SUM(total_laid_off_sum) OVER (ORDER BY year_month) AS rolling_total
FROM monthly_layoffs
ORDER BY year_month;
```

10. **Ranking Companies by Yearly Layoffs:**  
Created a multi-CTE query to rank companies by total layoffs per year, filtering for top rankings to highlight most impacted companies annually.  

```sql
WITH company_year AS (
  SELECT 
    company,
    YEAR(date) AS year,
    SUM(total_laid_off) AS total_laid_off_sum
  FROM layoffs
  GROUP BY company, year
),
company_year_ranked AS (
  SELECT 
    company,
    year,
    total_laid_off_sum,
    DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off_sum DESC) AS ranking
  FROM company_year
)
SELECT * FROM company_year_ranked WHERE ranking &lt;= 5 ORDER BY year, ranking;
```

---

🌟 **Key Features &amp; Methodologies:**  
- Employed SQL window functions like `SUM() OVER` and `DENSE_RANK() OVER` for cumulative sums and rankings.  
- Utilized substring manipulation to extract year-month for time series grouping.  
- Multi-level CTEs to organize complex ranking queries clearly.  
- Iterative approach: starting from simple aggregations, moving to advanced ranking and rolling totals.  
- Balanced qualitative assessment (company recognition, industry impact) with quantitative analysis.  

---

🔍 **Key Findings and Insights:**  
- Layoffs peaked in 2022, with early 2023 showing rising trends despite only three months of data.  
- The United States and India had the highest layoffs by volume.  
- Consumer retail and tech industries bore the brunt of layoffs.  
- Large tech giants (Google, Meta, Amazon) had repeated layoffs across multiple years.  
- Several companies underwent complete workforce layoffs (100%), indicating closures.  
- Rolling totals visualized the steady accumulation and acceleration of layoffs over time.  
- Yearly rankings highlighted top companies by layoffs, facilitating year-over-year comparisons.  

---

🏆 **Best Practices Followed:**  
- Started analysis on clean, reliable data ensuring accurate insights.  
- Leveraged SQL analytical functions efficiently for deep exploratory analysis.  
- Documented each analytical step with corresponding SQL code for reproducibility.  
- Applied careful filtering and ordering to maintain result clarity.  
- Explored multiple dimensions (time, company, industry, country) for holistic understanding.  
- Encouraged future expansion by highlighting data richness and potential further queries.  

---

🎯 **Project Outcome:**  
This project successfully demonstrated advanced SQL skills applied to exploratory data analysis on a complex layoffs dataset. It yielded actionable insights about workforce reductions across companies, industries, and regions during a critical economic period. The layered querying approach, from aggregate summaries to rolling totals and ranking, exemplifies practical data analysis applicable in real-world business intelligence and research scenarios.  

---

📄 **Summary:**  
By combining data cleaning with robust exploratory queries, this project presents a comprehensive analysis of layoffs from 2020-2023. It highlights notable patterns in layoffs across geographies, industries, and company stages, supported by detailed SQL code for reproducibility. This project serves as a strong portfolio example illustrating proficiency in SQL, critical thinking, and data storytelling—valuable assets for any data analyst or data engineer role.

---

If you want to see the whole SQL script Click [**Here**](https://github.com/nafisalzamee-lab/Data-Cleaning-and-Preparation-of-Global-Layoffs-Dataset-Using-MySQL/blob/main/SQL%20Script%20of%20Data%20Cleaning%20%26%20Preparation%20Using%20MySQL.sql)


[![Connect with me on LinkedIn](https://img.shields.io/badge/Connect%20with%20me-LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/md-nafis-al-zamee-a88a9024b)


