SELECT *
FROM PortfolioProject..['Covid Vaccines$']
ORDER BY 3, 4

SELECT *
FROM PortfolioProject..['Covid Deaths$']
WHERE continent IS NOT NULL
ORDER BY 3, 4


--Selecting Specific data
--Likelihood of death from Covid In Bangladesh 

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as fatality_rate
FROM PortfolioProject..['Covid Deaths$']
WHERE location = 'Bangladesh'
ORDER BY 1,2

--Total Cases Vs Population
--What % of population had Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS DeathPercent
FROM PortfolioProject..['Covid Deaths$'] 
--WHERE location = 'Bangladesh'
ORDER BY 1,2

--Looking at countries with the highest infection rate

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 AS InfectionPercent
FROM PortfolioProject..['Covid Deaths$'] 
--WHERE location = 'Bangladesh'
GROUP BY location, population
ORDER BY InfectionPercent, HighestInfectionCount DESC 

--Showing Countries with Highest Death Count per population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..['Covid Deaths$'] 
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


--Breaking Things down by continent
--Showing Continents with the highest death counts

 SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..['Covid Deaths$'] 
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--Global numbers
--Fatality Rate per date

SELECT date, SUM(new_cases) AS global_cases, SUM(new_deaths) AS global_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as fatality_rate
FROM PortfolioProject..['Covid Deaths$']
--WHERE location = 'Bangladesh'
GROUP BY date
HAVING SUM(new_cases)>0
ORDER BY 1,2

--Total Populations vs Vaccinations (CTE)

	
With popvsvac
AS(
SELECT deaths.continent,deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations
,SUM(CONVERT(BIGINT,vaccinations.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,deaths.date) AS rolling_vaccinations
FROM PortfolioProject..['Covid Deaths$'] AS deaths
JOIN PortfolioProject..['Covid Vaccines$'] AS vaccinations
	ON deaths.location = vaccinations.location
	AND deaths.date = vaccinations.date
WHERE deaths.continent IS NOT NULL
	--AND deaths.location = 'Bangladesh'
--ORDER BY 2,3
)
SELECT *, (rolling_vaccinations/population)*100 AS percent_vaccinations
FROM popvsvac




