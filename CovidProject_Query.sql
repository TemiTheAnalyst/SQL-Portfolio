
--TEMP TABLE

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccination NUMERIC,
RollingCountofPeopleVaccinated NUMERIC 
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
 dea.Date) AS RollingCountofpeoplevaccinated
FROM Covidpp..Covid_deaths dea
JOIN Covidpp..covid_vaccination vac
    ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingCountofpeoplevaccinated/population)*100 AS RollingCountPercentage
FROM #PercentPopulationVaccinated




SELECT *
FROM Covidpp..Covid_deaths
order by 3,4

--SELECT *
--FROM Covid_vaccination
--order by 3,4

--Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Covidpp..Covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2


--Looking at Total Cases vs Total Deaths 

SELECT Location, date, total_cases, total_deaths,  (total_deaths/total_cases)*100 AS DeathPercentage
FROM Covidpp..Covid_deaths
WHERE Location like '%Nigeria%'
ORDER BY 1,2

--Shows the likelihood of dying if you contact Covid-19 in Nigeria

SELECT Location, date, total_cases, total_deaths,  (total_deaths/total_cases)*100 AS DeathPercentage
FROM Covidpp..Covid_deaths
WHERE Location like '%Nigeria%'
ORDER BY 1,2

--Looking at Total cases vs Population
--Shows what percentage of population get covid

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS Percentageofinfectedpopulation
FROM Covidpp..Covid_deaths
WHERE continent IS NOT NULL
--WHERE Location like '%Nigeria%'
ORDER BY 1,2

--Looking at the highest case of infection

SELECT Location, population, Max(total_cases) AS Highestinfectioncount, MAX((total_cases/population))*100 AS Percentinfectedpopulation
FROM Covidpp..Covid_deaths
WHERE continent IS NOT NULL
--WHERE Location like '%Nigeria%'
GROUP BY Location, population 
ORDER BY  Percentinfectedpopulation DESC

--Looking at Hihgest death count by Location

SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Covidpp..Covid_deaths
WHERE continent IS NOT NULL
--WHERE Location like '%Nigeria%'
GROUP BY Location
ORDER BY TotalDeathCount DESC

SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Covidpp..Covid_deaths
WHERE continent IS NULL
--WHERE Location like '%Nigeria%'
GROUP BY Location
ORDER BY TotalDeathCount DESC

--Showing continents with the highest death count per population

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Covidpp..Covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC



--Global Numbers

SELECT date, SUM(New_cases) AS total_cases, SUM (CAST(New_deaths AS INT)) AS total_deaths, SUM(CAST(New_deaths AS INT))/SUM(New_cases)*100 AS DeathPercentage
FROM CovidPP..Covid_deaths
--WHERE Location like '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


--Looking at Total Population vs Vaccinations

SELECT *
FROM Covidpp..Covid_deaths dea
JOIN Covidpp..covid_vaccination vac
    ON dea.location = vac.location
	AND dea.date = vac.date
 
 
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 ,SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
 dea.Date) AS RollingCountofpeoplevaccinated
FROM Covidpp..Covid_deaths dea
JOIN Covidpp..covid_vaccination vac
    ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


--USE CTE

WITH PopvsVac (continent, Location, Date, population, new_vaccinations, RollingCountofpeoplevaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
 dea.Date) AS RollingCountofpeoplevaccinated
FROM Covidpp..Covid_deaths dea
JOIN Covidpp..covid_vaccination vac
    ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingCountofpeoplevaccinated/population)*100 AS Rollingcountpercentage
FROM PopvsVac



--Creating View to store data for later visualizations


CREATE VIEW RollingCountofpeoplevaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
 dea.Date) AS RollingCountofpeoplevaccinated
FROM Covidpp..Covid_deaths dea
JOIN Covidpp..covid_vaccination vac
    ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


