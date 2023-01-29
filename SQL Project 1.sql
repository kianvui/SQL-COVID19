SELECT *
FROM coviddeaths
ORDER BY 3,4;	

--SELECT *
--FROM covidvaccination
--ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2;


--TOTAL CASES VS TOTAL DEATHS IN %
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location like '%Singapore%'
ORDER BY 1,2;


SELECT *
FROM coviddeaths
JOIN
FROM covidvaccination

-- TOTAL CASES VS POPULATION
SELECT location, date, Population, total_cases, (total_cases/population)*100 AS case_Percentage
FROM coviddeaths
WHERE location like '%Singapore%'
ORDER BY 1,2;

--country with highest infection rate 
SELECT location, Population, MAX(total_cases) AS highest_infection_count, MAX(total_cases/population)*100 AS Percent_population_infected
FROM coviddeaths
WHERE continent is NOT NULL
GROUP BY location,population
ORDER BY Percent_population_infected DESC;

--Countries with highest death count per population

SELECT location, MAX(cast(total_deaths AS int)) as TotalDeathCount
FROM coviddeaths
WHERE continent is NOT NULL	
GROUP BY location
ORDER BY TotalDeathCount DESC;

--Continent with highest death count per population
SELECT continent, MAX(cast(total_deaths AS int)) as TotalDeathCount
FROM coviddeaths
WHERE continent is not NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--Global number
SELECT Sum(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths,SUM(cast(new_deaths as int))/Sum(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent is not NULL 
--GROUP BY date
ORDER BY 1,2;

SELECT Sum(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths,SUM(cast(new_deaths as int))/Sum(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent is not NULL 
ORDER BY 1,2;

total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN
covidvaccination vac
    on dea.location= vac.location
	and dea.date=vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3;


--use CTE

With PopvsVac (Continent,location,Date,Population, New_vaccination, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN
covidvaccination vac
    on dea.location= vac.location
	and dea.date=vac.date
WHERE dea.continent is NOT NULL
)

SELECT *, (RollingPeopleVaccinated/Population)*100 
FROM PopvsVac



--temp table

Create table #percentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric
new_vaccinations numeric
RollingPeopleVaccinated numeric
)

Insert into #percentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN
covidvaccination vac
    on dea.location= vac.location
	and dea.date=vac.date
WHERE dea.continent is NOT NULL

SELECT *, (RollingPeopleVaccinated/Population)*100 
FROM #percentPopulationVaccinated

--create view to store data for visualization

Create view PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN
covidvaccination vac
    on dea.location= vac.location
	and dea.date=vac.date
WHERE dea.continent is NOT NULL

Select *
FROM PercentPopulationVaccinated