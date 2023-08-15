 -- Covid 19 Dashboard, Data on April 26, 2023

 -- 1. Total Cases, Total Death and Vaccination Information (Doses, People vaccinated) By Location
Select Dea.location as Location, sum(Dea.new_cases) as TotalCases, sum(Dea.new_deaths) as TotalDeath, 
	max(cast(Vac.total_vaccinations as bigint)) as TotalDoses, max(cast(Vac.people_vaccinated as bigint)) as PeopleVaccinated, 
	max(cast(Vac.people_fully_vaccinated as bigint)) as PeopleFullyVaccinated, max(cast(Vac.total_vaccinations_per_hundred as float)) as DosesPer100
From PortfolioProject..CovidDeaths as Dea 
Join PortfolioProject..CovidVaccination as Vac
	On Dea.location = Vac.location
	And Dea.date = Vac.date
Where Dea.continent is not null
Group By Dea.location
Order By Dea.location;

-- 2. Total cases and deaths by continent until now
Select continent as Continent, sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths
From PortfolioProject..CovidDeaths
where continent is not null
Group By continent
Order By TotalCases desc;

Select *
From PortfolioProject..CovidVaccination
where continent is not null


-- 3. Global Situation - total cases weekly
With table1 as
(
	Select datediff(week, '2020-01-02', date) as WeekNumber, date, sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths
	From PortfolioProject..CovidDeaths
	Where continent is not null
	Group By date
)
Select max(date) as ReportDate, sum(TotalCases) as TotalCases, sum(TotalDeaths) as TotalDeath
From table1
Group By WeekNumber 
Order By WeekNumber;

-- 4. Global Situation - total death weekly
With table1 as
(
	Select datediff(week, '2020-01-02', date) as WeekNumber, date, sum(new_deaths) as TotalDeaths
	From PortfolioProject..CovidDeaths
	Where continent is not null
	Group By date
)
Select max(date) as ReportDate, sum(TotalDeaths) as TotalDeath
From table1
Group By WeekNumber 
Order By WeekNumber;

-- 5. Situation by Continent - total cases and deaths weekly
With table2 as
(
	Select datediff(week,'2020-01-02',date) as WeekNumber, date, continent, sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeath
	From PortfolioProject..CovidDeaths
	Where continent is not null
	Group By date, continent
)
Select continent, max(date) as ReportDate,  sum(TotalCases) as TotalCases, sum(TotalDeath) as TotalDeath
From table2
Group By WeekNumber, continent
Order By continent, WeekNumber;

--6. Situtation by countries - total cases and deaths weekly
With table3 as
(
	Select datediff(week,'2020-01-02',date) as WeekNumber, date, location, new_cases as TotalCases, new_deaths  as TotalDeath
	From PortfolioProject..CovidDeaths
	Where continent is not null
	And location in ('United States','Canada', 'China', 'India', 'France','Germany','Brazil','Japan','South Korea','Italy','United Kingdom',
		'Russia')
	--Group By location, date
	--Order By location, date
)
Select location, max(date) as ReportDate,  sum(TotalCases) as TotalCases, sum(TotalDeath) as TotalDeath
From table3
Group By location, WeekNumber
Order By location, WeekNumber;



