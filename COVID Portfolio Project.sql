Select location, date, total_cases,	new_cases, total_deaths, population
from PortfolioProject..Covid_Deaths
Order by 1,2
----------------------------------------------------------------------------------------------------
--Looking at Total Cases vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from PortfolioProject..Covid_Deaths
order by 1,2 
----------------------------
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from PortfolioProject..Covid_Deaths
Where location  = 'India'
--And date = '2022-03-01'
order by 1,2 
------------------------------------------------------------------------------------------------------
--Looking at Total Cases vs Population
--Shows what  percentage of population got covid

Select location, date, total_cases, total_deaths, population, (total_cases/ population)* 100 as CasesPercentage
from PortfolioProject..Covid_Deaths
Where location  = 'India'

order by 1,2 
---------------------------------------------------------------------------------------------------------
--Looking at countries with Highest Infection Rate compared to population 
Select location, Population, MAX(total_cases) as HighInfectionCount, 
Max((total_cases/population))*100 as PercentPopulatioInfected
from PortfolioProject..Covid_Deaths
Group by location, population
Order by PercentPopulatioInfected desc
;
--------------------------------------------------------------------------------------------------------
--Showing Countries with Highest Death Count per calculation 
Select location, MAX(Cast(total_deaths as int )) as TotalDeathCount
from PortfolioProject..Covid_Deaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc


---------------------------------------------------------------------------------------------------------
-- Lets break things down by continent 
Select continent, MAX( CAST(total_deaths as int)) as totaldeathcount
from PortfolioProject..Covid_Deaths
Where continent is not null
Group by continent
--And date = '2022-03-01'
order by totaldeathcount desc
---------------------------------------------------------------------------------------------------


-- Global Numbers 

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from PortfolioProject..Covid_Deaths
Where location  like '%India%'
--And date = '2022-03-01'
order by 1,2 

--------------------------------------
--total population vs Vaccinations 

DROP Table if exists #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

Select *, (RollingPeopleVaccinated/Population) * 100 
from #percentpopulationvaccinated

----------------------------------------------------------------------------------------------
	
-- Creating view to store data for later visualization 

Create view percentpopulationvaccinated as 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by 
dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select * from percentpopulationvaccinated;