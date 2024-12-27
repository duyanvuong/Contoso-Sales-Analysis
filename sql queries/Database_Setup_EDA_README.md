# Create Database

### [Source code here](/sql%20queries/01_Database_Setup/01_Create_Database.sql)

The database that I have created will include
- 1 Fact table
    - FactSales
- 8 Dimensions
    - DimDate
    - DimChannel
    - DimPromotion
    - DimStore, DimGeography
    - DimProduct, DimProductSubcategory, DimProductCategory

# Extracting data

### [Source code here](/sql%20queries/01_Database_Setup/02_Extracting_Data.sql)

All the data are extracted from ContosoRetailDW using the following SQL scripts
```sql
insert into DimDate (DateKey, Year, MonthName, Day, Quarter)
select
	DateKey,
	CalendarYear as Year,
	CalendarMonthLabel as MonthName,
	DAY(DateKey) as Day,
	CalendarQuarterLabel as Quarter
from ContosoRetailDW..DimDate
```
Different columns will be selected for different dimensions

# Data cleaning

### [Source code here](/sql%20queries/01_Database_Setup/04_Data_Cleaning.sql)

```sql
select 
    COUNT(*) as TotalRows,
    SUM(IIF(ContinentName is null, 1, 0)) as MissingValueContinentName,
    SUM(IIF(CityName is null, 1, 0)) as MissingValuesCityName,
    SUM(IIF(StateProvinceName is null, 1, 0)) as MissingValuesStateProvinceName,
    SUM(IIF(RegionCountryName is null, 1, 0)) as MissingValuesRegionCountryName
from DimGeography
```

After observing each table using the previous SQL script, I realized that only in `DimGeography` has null values. Those null values is stand for `Continent` (`CityName`, `StateProvince` and `RegionCountryName` are null).
Because of that, I decided to remove all null values that exist in `DimGeography using the following SQL scripts

```sql
delete from DimGeography
where CityName IS NULL
```

# Updating data

### [Source code here](/sql%20queries/01_Database_Setup/04_Data_Cleaning.sql)

In the origin data warehouse provided by Microsoft, I realized that the date column is all the way to 2007 and I want the data is up to date. So I decided to update `DateKey` column to the most recent time.

```sql
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
```