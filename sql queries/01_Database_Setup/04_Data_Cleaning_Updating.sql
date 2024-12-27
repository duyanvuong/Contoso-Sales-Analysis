use ContosoRetail

-- DimGeography

-- Dropping NULL values in DimGeography

delete from DimGeography
where CityName IS NULL

-- DimDate
select * from DimDate

-- Update Year for DateKey
delete from DimDate where DateKey = '2008/02/28'

update DimDate
set DateKey = CASE 
					WHEN YEAR(DateKey) = 2005 THEN DATEADD(YEAR, 2018 - 2005, DateKey)
					WHEN YEAR(DateKey) = 2006 THEN DATEADD(YEAR, 2019 - 2006, DateKey)
					WHEN YEAR(DateKey) = 2007 THEN DATEADD(YEAR, 2020 - 2007, DateKey)
					WHEN YEAR(DateKey) = 2008 THEN DATEADD(YEAR, 2021 - 2008, DateKey)
					WHEN YEAR(DateKey) = 2009 THEN DATEADD(YEAR, 2022 - 2009, DateKey)
					WHEN YEAR(DateKey) = 2010 THEN DATEADD(YEAR, 2023 - 2010, DateKey)
					WHEN YEAR(DateKey) = 2011 THEN DATEADD(YEAR, 2024 - 2011, DateKey)
				END

-- Update Year column
update DimDate
set Year = YEAR(DateKey)

-- Remove duplicate
delete from DimDate where DateKey = '2008-02-29 00:00:00.000'

-- Insert days for 2020 and 2024
insert into DimDate (DateKey, Year, MonthName, Day, Quarter) values ('2020-02-29', 2020, 'February', 29, 'Q1')
insert into DimDate (DateKey, Year, MonthName, Day, Quarter) values ('2024-02-29', 2024, 'February', 29, 'Q1')

-- Update DateKey in FactSales

update FactSales
set DateKey = '2024-02-29 00:00:00.000' 
where DateKey = '2008-02-29 00:00:00.000'

update FactSales
set DateKey = CASE 
					WHEN YEAR(DateKey) = 2007 THEN DATEADD(YEAR, 2022 - 2007, DateKey)
					WHEN YEAR(DateKey) = 2008 THEN DATEADD(YEAR, 2023 - 2008, DateKey)
					WHEN YEAR(DateKey) = 2009 THEN DATEADD(YEAR, 2024 - 2009, DateKey)
					ELSE DateKey
				END