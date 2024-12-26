use ContosoRetail

/*
Check if there is any missing values in every single table using the query above, it will contain:
- Total rows of records of each table
- Total missing values of each columns in a table
*/

/*
Only DimGeography has null values
- It has null values because it represent Continents, or a States, Countries
- Because of that, I decided to remove all the records that has a CityName is null
*/

-- Checking for missing values

-- FactSales

select 
	COUNT(*) as TotalRows,
	SUM(IIF(UnitCost is null, 1, 0)) as MissingUnitCost,
	SUM(IIF(UnitPrice is null, 1, 0)) as MissingUnitPrice,
	SUM(IIF(SalesQuantity is null, 1, 0)) as MissingSalesQuantity,
	SUM(IIF(ReturnQuantity is null, 1, 0)) as MissingReturnQuantity,
	SUM(IIF(ReturnAmount is null, 1, 0)) as MissingReturnAmount,
	SUM(IIF(DiscountQuantity is null, 1, 0)) as MissingDiscountQuantity,
	SUM(IIF(DiscountAmount is null, 1, 0)) as MissingDiscountAmount,
	SUM(IIF(TotalCost is null, 1, 0)) as MissingTotalCost,
	SUM(IIF(SalesAmount is null, 1, 0)) as MissingSalesAmount
from FactSales

-- DimStore

select 
    COUNT(*) as TotalRows,
    SUM(IIF(StoreType is null, 1, 0)) as MissingValueStoreType,
    SUM(IIF(StoreName is null, 1, 0)) as MissingValuesStoreName
from DimStore

-- DimGeography

select 
    COUNT(*) as TotalRows,
    SUM(IIF(ContinentName is null, 1, 0)) as MissingValueContinentName,
    SUM(IIF(CityName is null, 1, 0)) as MissingValuesCityName,
    SUM(IIF(StateProvinceName is null, 1, 0)) as MissingValuesStateProvinceName,
    SUM(IIF(RegionCountryName is null, 1, 0)) as MissingValuesRegionCountryName
from DimGeography

-- DimProduct

select 
    COUNT(*) as TotalRows,
    SUM(IIF(ProductName is null, 1, 0)) as MissingValuesProductName
from DimProduct

-- DimProductSubcategory

select 
    COUNT(*) as TotalRows,
    SUM(IIF(ProductSubcategoryName is null, 1, 0)) as MissingValuesProductSubcategoryName
from DimProductSubcategory

-- DimProductCategory

select 
    COUNT(*) as TotalRows,
    SUM(IIF(ProductCategoryName is null, 1, 0)) as MissingValuesProductCategoryName
from DimCategory

-- DimDate

select
    COUNT(*) as TotalRows,
    SUM(IIF(Year is null, 1, 0)) as MissingValuesYear,
    SUM(IIF(MonthName is null, 1, 0)) as MissingValuesMonthName,
    SUM(IIF(Day is null, 1, 0)) as MissingValuesDay,
    SUM(IIF(Quarter is null, 1, 0)) as MissingValuesQuarter
from DimDate

-- DimChannel

select 
    COUNT(*) as TotalRows,
    SUM(IIF(ChannelName is null, 1, 0)) as MissingValuesChannelName
from DimChannel

-- DimPromotion

select
    COUNT(*) as TotalRows,
    SUM(IIF(PromotionName is null, 1, 0)) as MissingValuesPromotionName,
    SUM(IIF(DiscountPct is null, 1, 0)) as MissingValuesDiscountPct
from DimPromotion