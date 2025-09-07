# Exploratory Data Analysis on Layoffs Dataset with SQL

### 📊 **Project Overview:**  
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
### 🛠️🧩 Key Processes Performed:  
- Examined maximum layoffs in single events  
- Grouped layoffs by company, industry, country, and year  
- Extracted and manipulated date fields for monthly and yearly aggregation  
- Calculated rolling totals to track cumulative layoffs over time  
- Ranked companies by layoffs per year using window functions and CTEs  

---

### 🌟 **Key Features & Methodologies:**
---
1. **Initial Data Exploration and Maximum Layoffs Check:**  
The analysis began by inspecting the maximum layoffs reported on any single day and identifying companies with total workforce layoffs (100%). This provided context on scale and severity.  

```sql
select max(total_laid_off),max(percentage_laid_off)
from layoff_staging2;

select *
from layoff_staging2
where percentage_laid_off= 1
order by total_laid_off desc;
```

2. **Sorting Companies by Largest Layoffs:**  
To identify which companies had the largest single layoffs, data was ordered descending by total layoffs.  

```sql
select company, max(total_laid_off) as largest_single_layoff
from layoff_staging2
group by company
order by largest_single_layoff desc;
```

3. **Summing Total Layoffs by Company:**  
Grouping layoffs by company to get cumulative layoffs over the data period.  

```sql
select company, sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;
```

4. **Checking Date Range of Dataset:**  
Determined the temporal span of the dataset to understand coverage.  

```sql
select min(`date`),max(`date`)
from layoff_staging2;
```

5. **Industry-wise Layoffs Aggregation:**  
Summed total layoffs by industry to spot hardest hit sectors.  

```sql
select industry, sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;
```

6. **Country-wise Layoffs Aggregation:**  
Identified countries with most layoffs.  

```sql
select country, sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc ;
```

7. **Yearly Layoffs Aggregation:**  
Extracted year from date and grouped layoffs by year to observe trends over time.  

```sql
select year(`date`), sum(total_laid_off)
from layoff_staging2
group by year(`date`)
order by 2 desc ;
```

8. **Stage-wise Layoffs Analysis:**  
Grouped layoffs by company funding stage to analyze impact across company maturity levels.  

```sql
select stage, sum(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc ;
```

9. **Rolling Total Layoffs by Month:**  
Calculated rolling cumulative layoffs month by month using substring extraction of year and month from the date, then applying window functions.  

```sql
select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoff_staging2
where substring(`date`,1,7) is not null
Group by `Month`
order by 1 asc;

with Rolling_total as
(
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date`,1,7) is not null
Group by `Month`
order by 1 asc
)
select `month`, total_off,
sum(total_off) over (order by `month`) as Rollin_total
from Rolling_total;
```

10. **Ranking Companies by Yearly Layoffs:**  
Created a multi-CTE query to rank companies by total layoffs per year, filtering for top rankings to highlight most impacted companies annually.  

```sql
select company, year(`date`), sum(total_laid_off)
from layoff_staging2
group by company, year(`date`)
order by company asc;

with company_year (company, years, total_laid_off) as 
(
select company, year(`date`) as years, sum(total_laid_off)
from layoff_staging2
group by company, year(`date`)
), 
Company_year_rank as
(select*,
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null)
select*
from company_year_rank
where ranking<= 5
```

---

### 🔍 **Key Findings and Insights:**  
- Layoffs peaked in **2022** llikely due to Covid, with early 2023 showing rising trends despite only three months of data.  
- The **United States** and **India** had the highest layoffs by volume.  
- **Consumer retail** and **tech** industries bore the brunt of layoffs.
- Tech giant **Amazon** had the highest total layoffs among all companies during the tenure of March 2020 to March 2023.
- **Google** had the largest single lay off among companies.
- Large tech giants (Google, Meta, Amazon) had repeated layoffs across multiple years.  
- Several companies underwent complete workforce layoffs **(100%)**, indicating closures.  
- Rolling totals visualized the steady accumulation and acceleration of layoffs over time.
   
- Yearly rankings highlighted top companies by layoffs, facilitating year-over-year comparisons.  
 ![yearly layoff ranking.png.png](yearly%20layoff%20ranking.png.png)
---

🏆 **Best Practices Followed:**  
- Started analysis on clean, reliable data ensuring accurate insights.  
- Leveraged SQL analytical functions efficiently for deep exploratory analysis.  
- Documented each analytical step with corresponding SQL code for reproducibility.  
- Applied careful filtering and ordering to maintain result clarity.  
- Explored multiple dimensions (time, company, industry, country) for holistic understanding.  
- Encouraged future expansion by highlighting data richness and potential further queries.  

---

 ### **•🎯Project Outcome:**  
- Delivered deep insights into layoffs trends from 2020 to 2023, highlighting peak years and most affected regions and industries.  
- Demonstrated proficiency in advanced SQL techniques such as window functions, CTEs, and substring operations.  
- Provided a replicable, expandable SQL framework for analyzing complex real-world datasets.  
- Produced actionable findings useful for economic research, workforce planning, or business intelligence.  
- Created a strong portfolio piece showcasing data exploration skills and SQL expertise, ready to impress recruiters and stakeholders.  
 

---

### **• Key Analyses Performed:**  
- **Maximum Layoffs Identification:** Found the largest layoff events and companies with 100% layoffs.  
- **Aggregate Layoffs by Company:** Summed total layoffs per company to assess overall impact.  
- **Industry and Country Impact Analysis:** Grouped data to identify which sectors and regions were hardest hit.  
- **Temporal Trend Analysis:** Used year, month extraction and rolling sums to analyze layoffs progression over time.  
- **Company-Year Ranking:** Ranked companies annually based on layoffs using window functions and dense ranking for yearly comparison of impact.  




---

📄 **Summary:**  
By combining data cleaning with robust exploratory queries, this project presents a comprehensive analysis of layoffs from 2020-2023. It highlights notable patterns in layoffs across geographies, industries, and company stages, supported by detailed SQL code for reproducibility. This project serves as a strong portfolio example illustrating proficiency in SQL, critical thinking, and data storytelling—valuable assets for any data analyst or data engineer role.

---

If you want to see the whole SQL script Click [**Here**](https://github.com/nafisalzamee-lab/Exploratory-Data-Analysis-on-Company-Layoff-Data-Using-MySQL/blob/main/SQL%20Script%20of%20EDA%20project.sql)


[![Connect with me on LinkedIn](https://img.shields.io/badge/Connect%20with%20me-LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/md-nafis-al-zamee-a88a9024b)
