SELECT date,SUM(new_cases) AS TotalDailyCases,SUM(new_deaths) AS TotalDailyDeath,
	  (SUM(new_deaths)/SUM(new_cases))*100.0 AS DailyDeathPercentage
FROM CSVCovidDeaths
WHERE iso_code not like '%OWID%'
GROUP BY date
ORDER BY date
ALTER TABLE CSVCovidDeaths ALTER COLUMN date date;


--Looking at Total Population vs Vaccinations
WITH CTE AS(
SELECT dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))
over (partition by dea.location order by dea.location,
dea.date) AS RollingPeopleVaccinated
FROM CSVCovidVaccinations vac
JOIN CSVCovidDeaths dea
ON vac.location = dea.location
AND vac.date = dea.date
where dea.iso_code not like '%OWID%'
--order by 2,3
)

SELECT *, RollingPeopleVaccinated/population*100
FROM CTE




--TEMP TABLE
Create table #PercentPopulationVaccinated4
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population bigint,
New_vaccinations int,
RollingPeopleVaccinated int
)

Insert into #PercentPopulationVaccinated4
SELECT dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))
over (partition by dea.location order by dea.location,
dea.date) AS RollingPeopleVaccinated
FROM CSVCovidVaccinations vac
JOIN CSVCovidDeaths dea
ON vac.location = dea.location
AND vac.date = dea.date
where dea.iso_code not like '%OWID%'

SELECT *, RollingPeopleVaccinated/population*100
FROM #PercentPopulationVaccinated4

CREATE VIEW PercentPopulationVaccinated4 AS (
SELECT dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))
over (partition by dea.location order by dea.location,
dea.date) AS RollingPeopleVaccinated
FROM CSVCovidVaccinations vac
JOIN CSVCovidDeaths dea
ON vac.location = dea.location
AND vac.date = dea.date
where dea.iso_code not like '%OWID%'
)

SELECT *
FROM [dbo].[PercentPopulationVaccinated4]