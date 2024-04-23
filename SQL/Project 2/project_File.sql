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
















