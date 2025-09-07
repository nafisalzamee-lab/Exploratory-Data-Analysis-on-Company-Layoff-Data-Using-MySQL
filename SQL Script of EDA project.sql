-- Exploratory data analysis

select max(total_laid_off),max(percentage_laid_off)
from layoff_staging2;

select *
from layoff_staging2
where percentage_laid_off= 1
order by total_laid_off  desc;

select company, total_laid_off 
from layoff_staging2
order by total_laid_off  desc;

select company, sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

select min(`date`),max(`date`)
from layoff_staging2;

select industry, sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc ;

select monthname(`date`), sum(total_laid_off)
from layoff_staging2
group by monthname(`date`)
order by 2 desc ;

select year(`date`), sum(total_laid_off)
from layoff_staging2
group by year(`date`)
order by 2 desc ;

select stage, sum(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc ;

select company, avg(percentage_laid_off)
from layoff_staging2
group by company
order by 2 desc ;

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


select company, sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

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

