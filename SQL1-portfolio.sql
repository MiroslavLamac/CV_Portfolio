--Link to Dataset: https://ourworldindata.org/covid-deaths

Select * 
from PortfolioProject..CovidDeaths
Order by 3,4

--Select * 
--from PortfolioProject..CovidVaccinations
--Order by 3,4

-- Select data that we are going to use
Select location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths
Order by 1,2

--Looking at total cases vs total death
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
from PortfolioProject..CovidDeaths
Order by 1,2


 -- % of death by covid "Location"
 Select Location, date, total_cases, total_deaths, (total_deaths/total_cases*100) as Deathpercentage
 from PortfolioProject..coviddeaths
 Where location like 'Slov%'
 Order by 1,2

-- % of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as InfectedPopulation
 from PortfolioProject..coviddeaths
 Where location = 'Slovakia'
 Order by 1,2

 -- % with hights infections rate to population
 Select Location, population, MAX(total_cases) as HighestInfections, MAX((total_deaths/population))*100 as PercentageInfectedPopulation
 from PortfolioProject..CovidDeaths
 --Where location = 'Slovakia'
 group by Location, population
 Order by PercentageInfectedPopulation desc


 --showing country with the highest death rate
  Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
 from PortfolioProject..CovidDeaths
 --Where location = 'Slovakia'
 where continent is not null
 group by Location
 Order by TotalDeathCount desc


 -- showing continent with the highest death rate
  Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
 from PortfolioProject..CovidDeaths
 where continent is not null
 group by continent
 Order by TotalDeathCount desc 

 -- Looking at Total cases vs Population
 -- show what pecentage of population have got covid
  Select Location, date, total_cases, Population, (total_cases/population*100) as Deathpercentage
 from PortfolioProject..coviddeaths
 Where location like 'Slov%'
 Order by Deathpercentage desc

 -- Looking at countries with Highest Infection Rate compared to Population
  Select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as PercentPopulationInfected
 from PortfolioProject..CovidDeaths
 --Where location = 'Slovakia'
 group by Location, population
 Order by PercentPopulationInfected desc

  -- showing continent with the highest death rate
 Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
 from PortfolioProject..CovidDeaths
 where continent is not null
 group by location
 Order by TotalDeathCount desc 

 -- Showing continent with highest death coune per population
 Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
 from PortfolioProject..CovidDeaths
 where continent is not null
 group by continent
 Order by TotalDeathCount desc 

 --Global numbers by date
 Select  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
 from PortfolioProject..coviddeaths
 --Where location like 'Slov%'
 where continent is not null
 group by date
 Order by 1,2

 --Total global number
 Select   SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
 from PortfolioProject..coviddeaths
 --Where location like 'Slov%'
 where continent is not null
 --group by date
 Order by 1,2

 -- Looking at Total Population vs Vaccinations

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 from PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3
 
  -- Counting vaccinated people every day
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE
with PopvsVac (continent, location, date, population,New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date
) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/population)*100 as VaccinatedvsPopulation from PopvsVac


-- Temp Table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
Select *, (RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated

-- Creating view to store data for later visualizations 
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select * 
from PercentPopulationVaccinated
