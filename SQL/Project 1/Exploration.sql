select *
from PortfolioProjects..CovidDeaths
order by 3,4

--Select data that we are going to use 

Select Location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProjects..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths 
-- show likelihood of dying of a few contracts covered in your country 
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_percentage 
from PortfolioProjects..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at total cases vs population (Percentage of people got Covid)

USE PortfolioProjects;

select Location,  population,MAX(total_cases) as highest, Max(total_cases/population)*100 as Population_infected
from CovidDeaths
group by Location, population
order by Population_infected desc


-- Showing Countries with Highest Death Count per Population

select Location,  MAX(cast(Total_deaths as int)) as highest_Death
from CovidDeaths
where continent is not null
group by Location
order by highest_Death desc


-- breakdown through Continent
select continent,  MAX(cast(Total_deaths as int)) as highest_Death
from CovidDeaths
where continent is not null
group by continent
order by highest_Death desc
