SELECT *
FROM COVID19
--WHERE continent IS NOT NULL
ORDER BY 3,4


SELECT COUNT(*)
FROM COVID19

SELECT continent, location, date, total_cases, new_cases, total_deaths, new_deaths, population
FROM COVID19
WHERE continent IS NOT NULL
ORDER BY 2;


ALTER TABLE COVID19
ADD total_cases2 float; -- corvert data type from Nvarchar to float

UPDATE COVID19
SET total_cases2 = CONVERT(float, total_cases); -- update data type from Nvarchar to float
SELECT total_cases2
FROM COVID19

ALTER TABLE COVID19
ADD total_deaths2 float; -- corvert data type from Nvarchar to float

UPDATE COVID19
SET total_deaths2 = CONVERT(float, total_deaths); -- update data type from Nvarchar to float

--TOTAL CASES VS TOTAL DEATHS IN %
SELECT location, date, total_cases2, total_deaths2, (total_deaths2/Total_cases2)*100 AS DeathPercentage
FROM COVID19
--WHERE location like '%Singapore%'
ORDER BY 1,2

--NEW CASES VS NEW DEATHS IN %
SELECT
    location, date, new_cases, new_deaths,
    CASE
        WHEN new_cases = 0 THEN NULL 
        ELSE new_deaths/NULLIF(new_cases,0)*100 
    END AS DeathPercentage
FROM coviddeaths
WHERE location like '%Singapore%'
ORDER BY 1,2;

--Countries with highest death count

SELECT location, MAX(total_deaths2) as TotalDeathCount
FROM COVID19
WHERE continent is NOT NULL	
GROUP BY location
ORDER BY TotalDeathCount DESC;

--Countries with highest TOTAL CASES 

SELECT location, SUM(new_cases)
FROM COVID19
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY SUM(new_cases) DESC

SELECT location, MAX(total_vaccinations)
FROM COVID19
WHERE continent is NOT NULL
GROUP BY location
ORDER BY location DESC

SELECT location, total_vaccinations2
FROM COVID19
WHERE continent is NOT NULL



ALTER TABLE COVID19
ADD total_vaccinations2 float; -- corvert data type from Nvarchar to float

UPDATE COVID19
SET total_vaccinations2 = CONVERT(float, total_vaccinations); -- update data type from Nvarchar to float

-- TOTAL CASES VS POPULATION
SELECT location,Population, MAX(total_cases2), (MAX(total_cases2)/population)*100 AS case_Percentage
FROM COVID19
WHERE location like '%Singapore%'
ORDER BY 1,2

SELECT location,
	PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY total_cases2)  
       OVER () AS Median --(PARTITION BY total_cases2) AS MedianCont
FROM COVID19
--WHERE location like '%Saint%'

SELECT location,
	PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY total_cases2)  
       OVER(PARTITION BY location) AS MedianCont
FROM COVID19
WHERE continent IS NOT NULL
--WHERE location like '%Saint%'

Create view TOTAL_CASES_VS_POPULATIONAS AS
SELECT location,
	PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY total_cases2)  
       OVER(PARTITION BY location) AS MedianCont
FROM COVID19
WHERE continent IS NOT NULL
--WHERE location like '%Saint%'

SELECT location,MedianCont
FROM TOTAL_CASES_VS_POPULATIONAS
GROUP BY location, MedianCont
ORDER BY MedianCont DESC

SELECT location, AVG(total_cases2)
FROM COVID19
WHERE location Like '%United%'
GROUP BY location
