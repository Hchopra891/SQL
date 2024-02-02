-----------------------------------------------------------------------------------------------
select * 
from CovidDeaths
where continent is not null
order by 3,4


-----------------------------------------------------------------------------------------------


select *
from covidvaccinations
order by 3,4


-----------------------------------------------------------------------------------------------
-- SELECT THE DATA we are using.



select location, date, total_cases, new_cases, population
from coviddeaths
where continent is not null
order by 1,2



--looking at total cases vs total deaths


select location, date, total_cases, total_deaths, 
(total_deaths/total_cases)*100 as deathPercentage 
from coviddeaths
where location like '%states%' 
and continent is not null
order by 1,2



--looking at the total cases vs population
-- showing what percentage of population got covid



select location, date, total_cases, population, 
(total_cases/population)*100 as population
from coviddeaths
where continent is not null
--where location like '%canada%'
order by 1,2

-----------------------------------------------------------------------------------------------


-- countries with highest infection rate compared to population

select location, population, max(total_cases) as HighestInfectionCount, 
max (total_cases/population)*100 as populationpercentage
from CovidDeaths
where continent is not null
group by location, population
order by populationpercentage desc

 
 -----------------------------------------------------------------------------------------------

--- how many people died ? / death count


select location,  max(cast(total_deaths as int)) as HighestdeathCount
from CovidDeaths
where continent is  null
group by location
order by  HighestdeathCount desc


-----------------------------------------------------------------------------------------------


---showing the continent wiht the highest death count



select continent,  max(cast(total_deaths as int)) as HighestdeathCount
from CovidDeaths
where continent is not null
group by continent
order by  HighestdeathCount desc


-----------------------------------------------------------------------------------------------

--global numbers 

select  --date, 
sum(new_cases)as totalcases , SUM(cast(new_deaths as int)) as totaldeaths , 
(sum(cast(new_deaths as int ))/sum(new_cases))*100 as deathPercentage 
from coviddeaths
where continent is not null
--group by date
order by 1,2


-----------------------------------------------------------------------------------------------

--looking at total population vs vaccinations

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(cast(cv.new_vaccinations as int ))
over(partition by cd.location order by cd.location,cd.date) as rollingsumVaccine,

from CovidDeaths cd
join CovidVaccinations cv
	on cd.location = cv.location
	and cd.date= cv.date
where cd.continent is not null
order by 2,3


-----------------------------------------------------------------------------------------------
---- use cte

with popVSvac ( Continent, location, date, population, new_vaccinations, rollingsumvaccine)
as 
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(cast(cv.new_vaccinations as int ))
over(partition by cd.location order by cd.location,cd.date) as rollingsumVaccine
-- , (rollingsumvaccine /population) *100

from CovidDeaths cd
join CovidVaccinations cv
	on cd.location = cv.location
	and cd.date= cv.date
where cd.continent is not null
--order by 2,3
)
select *, (rollingsumvaccine /population) *100 as rsp
from popVSvac



-----------------------------------------------------------------------------------------------

-- temp tables

drop table if exists #percentppoulationvaccinated
create table #percentppoulationvaccinated
( continent nvarchar(255),
  location nvarchar (255),
  date datetime,
  population numeric,
  new_vaccinations numeric, 
  rollingsumvaccine numeric

)

insert into  #percentppoulationvaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(cast(cv.new_vaccinations as int ))
over(partition by cd.location order by cd.location,cd.date) as rollingsumVaccine
-- , (rollingsumvaccine /population) *100

from CovidDeaths cd
join CovidVaccinations cv
	on cd.location = cv.location
	and cd.date= cv.date
where cd.continent is not null
--order by 2,3


select * ,(rollingsumvaccine /population) *100 as rsp
from #percentppoulationvaccinated



-----------------------------------------------------------------------------------------------

--- create views

create view percentpopulationvaccinated as 
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(cast(cv.new_vaccinations as int ))
over(partition by cd.location order by cd.location,cd.date) as rollingsumVaccine
-- , (rollingsumvaccine /population) *100

from CovidDeaths cd
join CovidVaccinations cv
	on cd.location = cv.location
	and cd.date= cv.date
where cd.continent is not null
--order by 2,3


select *
from percentpopulationvaccinated