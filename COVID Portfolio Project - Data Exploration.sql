/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

SELECT *
FROM Portfolio..covid_vaccinations
WHERE continent is not NULL	
ORDER BY 3,4;

/**ALTER table dbo.covid_deaths
ALTER column total_deaths float
 **/ 
 
-- Select Data that we are going to be starting with
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country	
 SELECT location, date , total_cases, total_deaths, (total_cases / population)*100 AS Death_pecentage
 FROM Portfolio..covid_deaths
 WHERE location LIKE 'India'
 ORDER BY 1, 2;


 -- Looking at total_cases vs population
-- Shows what percentage of population got COVID 

  SELECT location, date , population , total_cases, (total_deaths/total_cases)*100 
 FROM Portfolio..covid_deaths
-- WHERE location LIKE 'India'
 ORDER BY 1, 2;

 -- Looking at countries with highest infection rate 

 SELECT location, population , MAX(total_cases) AS Highest_infrection, MAX((total_cases/population))*100 as percen_population_infected
 FROM Portfolio..covid_deaths
-- WHERE location LIKE 'India'
GROUP  BY location,population 
 ORDER BY percen_population_infected desc


 -- Showing the countries with highest death count

 SELECT location , MAX(total_deaths) as	Total_death_count
 FROM Portfolio..covid_deaths
 WHERE continent is NOT NULL 
 GROUP BY location
 ORDER BY Total_death_count DESC

 -- Lets break thing by continent 

	  SELECT continent, MAX(total_deaths) as Total_death_count
	 FROM Portfolio..covid_deaths
	 WHERE continent is NOT NULL 
	 GROUP BY continent
	 ORDER BY Total_death_count DESC

-- Looking at total population vs vaccination
	 
	 SELECT dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER ( partition by dea.location 
	 order by dea.location, dea.date) as rollingpeoplevaccinated			
	 FROM portfolio..covid_deaths dea
	 JOIN portfolio..covid_vaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 WHERE dea.continent is NOT NULL
	 ORDER BY 1,2


-- Using CTE to perform Calculation on Partition By in previous query

with popvsvac (continent, location, date, population, rollingpeoplevacccinated, new_vaccination)
as 
(
SELECT dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER ( partition by dea.location 	 
order by dea.location, dea.date) as rollingpeoplevaccinated			
FROM portfolio..covid_deaths dea
JOIN portfolio..covid_vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is NOT NULL
 )
 SELECT *, (rollingpeoplevacccinated/population)*100  
 from popvsvac
 
 -- Creating view to store data fro visulization 

CREATE view VaccinatedPopulationPercent as 
SELECT dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER ( partition by dea.location 	 
order by dea.location, dea.date) as rollingpeoplevaccinated			
FROM portfolio..covid_deaths dea
JOIN portfolio..covid_vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is NOT NULL
 
 
