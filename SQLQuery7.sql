Select Location, date, total_cases, new_cases, total_deaths, population
From Covid_Deaths
order by 1,2

--Total Cases VS Total Deaths: % Died from contraction of the virus in the US--

Select Location, date, total_cases,  total_deaths, (total_deaths / total_cases)*100 AS Mortality_Rate
From Covid_Deaths
where location like '%states%'
order by 1,2

--Total cases VS Population--

Select Location, date, total_cases,  population, (total_cases / population)*100 AS Infection_Rate
From Covid_Deaths
where location like '%states%'
order by 1,2

--Highest Infection Rate By Countries Population --
Select Location, population, Max(total_cases) As Top_Infection_Rate, Max((total_cases / population))*100 AS Percent_Infected
From Portfolio_Projects..Covid_Deaths
Group by population, location
order by Percent_Infected desc

--Countries with highest deth tolls per population--

Select Location, MAX(Cast(total_deaths as int)) as total_death_count
From Portfolio_Projects..covid_Deaths
where continent is not NULL
Group by Location 
order by total_Death_Count desc

--death count by continent--

Select continent, MAX(Cast(total_deaths as int)) as total_death_count
From Portfolio_Projects..covid_Deaths
where continent is not NULL
Group by continent 
order by total_Death_Count desc

-- GLOBAL NUMBERS--

Select  SUM(new_cases) as total_cases, SUM(Cast(new_deaths As INT)) as total_deaths, Sum(Cast(new_deaths as INT))/Sum(new_cases)*100 AS Global_Mortality_rate
From Portfolio_Projects..covid_Deaths
where continent is not null
--Group by date
order by 1,2

----Vaccinations----
--Check for join--
Select*
From 
	Portfolio_Projects..covid_Vax C,
	Portfolio_Projects..covid_Deaths D
Where
	D.Location=C.Location
	And D.Date= C.Date

--Population Vs Vaccinations--

Select 
	D.Continent, 
	D.Location, 
	D.date, 
	D.population, 
	V.new_vaccinations, 
	Sum(Cast(V.new_vaccinations As int)) Over (Partition by D.location order by D.location, D.Date) As Rolling_Vax_Population
From 
	Portfolio_Projects..covid_Vax V,
	Portfolio_Projects..covid_Deaths D
Where 
	D.Location = V.Location 
	And D.Date= V.Date 
	And D.continent is not null
order by 2,3
	

--Use CTE--

With PopulationVSVaccination (Continent, Location, Date, Population, New_Vaccinations, Rolling_Vax_Population)
as(
Select 
	D.Continent, 
	D.Location, 
	D.date, 
	D.population, 
	V.new_vaccinations, 
	Sum(Cast(V.new_vaccinations As int)) Over (Partition by D.location order by D.location, D.Date) As Rolling_Vax_Population
From 
	Portfolio_Projects..covid_Vax V,
	Portfolio_Projects..covid_Deaths D
Where 
	D.Location = V.Location 
	And D.Date= V.Date 
	And D.continent is not null
)
Select *, (Rolling_Vax_Population/Population)*100
From PopulationVSVaccination

--Create Views For Viz's in Tableau--

Create View PercentPopulationVaccinated AS
Select 
	D.Continent, 
	D.Location, 
	D.date, 
	D.population, 
	V.new_vaccinations, 
	Sum(Cast(V.new_vaccinations As int)) Over (Partition by D.location order by D.location, D.Date) As Rolling_Vax_Population
From 
	Portfolio_Projects..covid_Vax V,
	Portfolio_Projects..covid_Deaths D
Where 
	D.Location = V.Location 
	And D.Date= V.Date 
	And D.continent is not null
--order by 2,3

