-- Data Cleaning

SELECT 
    *
FROM
    layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns


CREATE TABLE layoffs_staging LIKE layoffs;

insert layoffs_staging
select *
from layoffs;

select *,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
from layoffs_staging;


-- The following works as a function 
with duplicate_cte as
(
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte -- Function call 
where row_num>1;


SELECT 
    *
FROM
    layoffs_staging
WHERE
    company = 'Casper';


-- Functions won't work with table updates (Delete is kinda table update) 
with duplicate_cte as
(
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
delete 
from duplicate_cte
where row_num>1;

drop table layoffs_staging2;

CREATE TABLE `layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    row_num INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;

SELECT 
    *
FROM
    layoffs_staging2;

insert into layoffs_staging2
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging;


DELETE FROM layoffs_staging2 
WHERE
    row_num > 1;


SELECT 
    *
FROM
    layoffs_staging2;


-- Standardized data 

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country
from layoffs_staging2;


select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;


update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';


select *
from layoffs_staging2
order by country asc;

-- working on time series 
select 'date', str_to_date('date', '%m/%d/%Y')
from layoffs_staging2;


UPDATE layoffs_staging2
SET date = str_to_date(date, '%m/%d/%Y');

alter table layoffs_staging2
modify column date DATE;

select * from layoffs_staging2;

-- Clear null and blank values 

select * from layoffs_staging2
where total_laid_off is Null
and percentage_laid_off is null;

select *
from layoffs_staging2
where industry is null
or industry = '';

select * 
from layoffs_staging2
where company = 'Airbnb';

-- Try using joins to fill the null values from the existing data 

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2
set industry = null
where industry = '';


update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select * 
from layoffs_staging2
where company = 'Airbnb';

select * 
from layoffs_staging2
where company like 'Bally%';

select * from layoffs_staging2;
-- We won't be able to populate total laid off and percentage laid off based on the data we have 

select * 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;


-- Exploratory data analysis 

select * 
from layoffs_staging2;

-- Gives the values of total laid off and percentage laid off from the entire data 
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

-- gives the table of the companies that are completely laid off  Ordered by fundraised 
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions DESC;

-- gives the table of Laid off based on company 
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

SELECT MIN(date), max(date)
from layoffs_staging2;

-- gives the table of Laid off based on industry 
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select * from layoffs_staging2;

-- total laid off value based on year 
select YEAR(date), sum(total_laid_off)
from layoffs_staging2
group by YEAR(date)
order by 1 desc;

-- Total light of based on funding stage 
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;


select substring(date, 1, 7) as month , sum(total_laid_off)
from layoffs_staging2
where substring(date, 1, 7) is not null
group by month
order by 1 ASC;


-- Creating a function for rolling total of layoffs   
with Rolling_total as
(
select substring(date, 1, 7) as month , sum(total_laid_off) as total_off
from layoffs_staging2
where substring(date, 1, 7) is not null
group by month
order by 1 ASC
)
select month, total_off, sum(total_off) over (order by month) as rolling_total
from Rolling_total;


select company, YEAR(date), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(date)
order by 3 desc;
 
 
 /* The code calculates the total number of employees laid off by each company per year, ranks them within each year
 based on the total layoffs, and selects the top 5 companies with the highest layoffs for each year. */
with Company_Year (Company, years, total_laid_off) as 
(
select company, YEAR(date), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(date)
), Company_Year_Rank as
(select *, dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
select * 
from Company_Year_Rank
where Ranking <=5;

/*
This SQL code first creates a Common Table Expression (CTE) named Company_Year that calculates the total number of employees laid off by each company per year. 
It groups the data by company and year, calculating the sum of layoffs for each group. 

Then, it creates another CTE named Company_Year_Rank, which assigns a rank to each company within each year based on the total number of layoffs, 
using the dense_rank() window function. The companies are ranked in descending order of total layoffs within each year.

Finally, it selects the rows from the Company_Year_Rank CTE where the ranking is less than or equal to 5, 
effectively retrieving the top 5 companies with the highest layoffs for each year.
*/
 
 
 
 
 
 
 
 