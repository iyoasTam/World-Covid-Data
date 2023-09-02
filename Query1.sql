SELECT *
FROM PortfolioProject..CSVCovidDeaths
--where continent is null
--WHERE iso_code not like '%OWID%'
ORDER BY 3,4


--select *
--from PortfolioProject..CovidVaccinations
--ORDER BY 3,4
SELECT location,date,total_cases,new_cases,total_deaths, population
FROM CSVCovidDeaths
ORDER BY 1,2

--Let's change the datatype of 'total_cases' and 'total_deaths'
--from varchar to float datatype inorder to do operations.
--Or we can just change *100 to *100.0 to do a float calculation in the percentage
ALTER TABLE CSVCovidDeaths ALTER COLUMN [total_cases] float;
ALTER TABLE CSVCovidDeaths ALTER COLUMN [total_deaths] float;

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
SELECT location,date, total_cases,total_deaths, (total_deaths/NULLIF(total_cases,0))*100 as DeathPercentage
FROM PortfolioProject..CSVCovidDeaths
ORDER BY 1,2

--Change the datatype of the column 'population'
ALTER TABLE CSVCovidDeaths ALTER COLUMN [population] bigint;

--Show Total Cases vs Population
SELECT location, MAX(total_cases) AS HighestInfection,population, MAX(total_cases/NULLIF(population,0))*100 as InfectedPercentage
FROM PortfolioProject..CSVCovidDeaths
GROUP BY location, population
ORDER BY 4 DESC;


--Shows TotalDeaths vs Population
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM CSVCovidDeaths
WHERE iso_code not like '%OWID%'
--WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


SELECT location,population, MAX(total_deaths) AS TotalDeathCount,
(MAX(total_deaths)/NULLIF(population,0))*100 AS DeathPercentage
FROM CSVCovidDeaths
WHERE iso_code not like '%OWID%'
GROUP BY location, population
ORDER BY DeathPercentage DESC

--Removes continents in the location columns
SELECT location,population, MAX(total_deaths) AS TotalDeathCount,
(MAX(total_deaths)/NULLIF(population,0))*100 AS DeathPercentage
FROM CSVCovidDeaths
WHERE iso_code not like '%OWID%'
GROUP BY location,population
ORDER BY DeathPercentage DESC

SELECT *
FROM PortfolioProject..CSVCovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--BREAKING DOWN BY CONTINENT
WITH CTE(Continent,Location,TotalDeathCount) AS(
SELECT continent,location, MAX(total_deaths)
FROM CSVCovidDeaths
WHERE iso_code not like '%OWID%'
GROUP BY continent, location
--order by 1, 3 DESC
)

SELECT continent, SUM(TotalDeathCount) AS DeathCountTotal
FROM CTE
GROUP BY continent
ORDER BY SUM(TotalDeathCount) DESC;

--GLOBAL NUMBERS
ALTER TABLE CSVCovidDeaths ALTER COLUMN new_deaths int
ALTER TABLE CSVCovidDeaths ALTER COLUMN new_cases int;





