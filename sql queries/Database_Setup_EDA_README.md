# [Create database](/sql%20queries/01_Database_Setup/01_Create_Database.sql)

The database that I have created will include
- 1 Fact table
    - FactSales
- 8 Dimensions
    - DimDate
    - DimChannel
    - DimPromotion
    - DimStore, DimGeography
    - DimProduct, DimProductSubcategory, DimProductCategory

# [Extracting data](/sql%20queries/01_Database_Setup/02_Extracting_Data.sql)

## [Source code here](/sql%20queries/01_Database_Setup/02_Extracting_Data.sql)

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