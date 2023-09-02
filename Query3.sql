WITH CTE AS(
SELECT iso_code,  [population], SUM([total_cases]) as TotalCase,SUM([total_deaths]) as TotalDeath
FROM PortfolioProject..CSVCovidDeaths
GROUP BY iso_code,  [population]
)

SELECT (TotalDeath/NULLIF(TotalCase,0))*100 AS DeathCasePercentage
FROM CTE