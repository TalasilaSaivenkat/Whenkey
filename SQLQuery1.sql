select *
from [Portfolio Project ( covid-19)]..['Covid deaths$']
order by 3,4

select *
from [Portfolio Project ( covid-19)]..['Covid vaccinations1$']
order by 3,4

select location, date , total_cases, new_cases, total_deaths, population
from [Portfolio Project ( covid-19)]..['Covid deaths$']
order by 1,2

--looking at total deaths vs total Cases

select location, date , total_deaths, total_cases, (total_deaths/total_cases)*100 as Deathpercentage
from [Portfolio Project ( covid-19)]..['Covid deaths$']
where location like '%India%'
and continent is not null
order by 1,2

-- looking at total cases vc populations
-- show what percentage of populations got covid

select location, date , population, total_cases, (total_cases/population)*100 as Deathpercentage
from [Portfolio Project ( covid-19)]..['Covid deaths$']
where location like '%India%'
order by 1,2

select location, date , population, total_cases, (total_cases/population)*100 as Deathpercentage
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--where location like '%India%'
order by 1,2

--looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) as Highestinfectioncount, max(total_cases/population)*100 as percentpopulationinfected
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--where location like '%India%'
group by location,  population
order by percentpopulationinfected desc

--showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as totaldeathcount 
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--where location like '%India%'
where continent is not null
group by location
order by totaldeathcount desc


--LET'S BREAK THINGS DOWN BY CONTINENT 

select continent, max(cast(total_deaths as int)) as totaldeathcount 
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--where location like '%India%'
where continent is not null
group by continent
order by totaldeathcount desc

select location, max(cast(total_deaths as int)) as totaldeathcount 
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--where location like '%India%'
where continent is null
group by location
order by totaldeathcount desc


select continent, max(cast(total_deaths as int)) as totaldeathcount 
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--where location like '%India%'
where continent is not null
group by continent
order by totaldeathcount desc

--global numbers

select date, SUM (new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--where location like '%India%'
where continent is not null
group by date
order by 1,2

--total death

select  SUM (new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--where location like '%India%'
where continent is not null
--group by date
order by 1,2

--Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
from [Portfolio Project ( covid-19)]..['Covid deaths$'] dea
join [Portfolio Project ( covid-19)]..['Covid vaccinations1$'] vac
   on dea.location =vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Visualazation Queries for tablue project
--01

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%india%'
where continent is not null 
--Group By date
order by 1,2

--02

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


--03

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


--04

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

--only in case you want to check them out
--01

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ( covid-19)]..['Covid deaths$'] dea
Join [Portfolio Project ( covid-19)]..['Covid vaccinations1$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3

--02
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%india%'
where continent is not null 
--Group By date
order by 1,2

--03 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%india%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--04

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%india%'
Group by Location, Population
order by PercentPopulationInfected desc

--05

Select Location, date, population, total_cases, total_deaths
From [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%india%'
where continent is not null 
order by 1,2

--06


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ( covid-19)]..['Covid deaths$'] dea
Join [Portfolio Project ( covid-19)]..['Covid vaccinations1$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


--07

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project ( covid-19)]..['Covid deaths$']
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
