use ContosoRetail

-- DimDate

insert into DimDate (DateKey, Year, MonthName, Day, Quarter)
select
	DateKey,
	CalendarYear as Year,
	CalendarMonthLabel as MonthName,
	DAY(DateKey) as Day,
	CalendarQuarterLabel as Quarter
from ContosoRetailDW..DimDate

-- DimChannel

insert into DimChannel (ChannelName)
select
	ChannelName
from ContosoRetailDW..DimChannel

-- DimPromotion

insert into DimPromotion (PromotionName, DiscountPct)
select
	PromotionName,
	DiscountPercent
from ContosoRetailDW..DimPromotion

-- DimGeography

insert into DimGeography (GeographyKey, ContinentName, CityName, StateProvinceName, RegionCountryName)
select
	GeographyKey,
	ContinentName,
	CityName,
	StateProvinceName,
	RegionCountryName
from ContosoRetailDW..DimGeography

-- DimStore

insert into DimStore (StoreKey, GeographyKey, StoreType, StoreName)
select
	StoreKey,
	GeographyKey,
	StoreType,
	StoreName
from ContosoRetailDW..DimStore

-- DimCategory

insert into DimCategory (ProductCategoryName)
select 
	ProductCategoryName
from ContosoRetailDW..DimProductCategory

-- DimProductSubcategory

insert into DimProductSubcategory (ProductSubcategoryKey, ProductSubcategoryName, ProductCategoryKey)
select 
	ProductSubcategoryKey,
	ProductSubcategoryName,
	ProductCategoryKey
from ContosoRetailDW..DimProductSubcategory

-- DimProduct

insert into DimProduct (ProductName, ProductSubcategoryKey)
select
	ProductName,
	ProductSubcategoryKey
from ContosoRetailDW..DimProduct

-- FactSales

insert into FactSales 
	(DateKey, ChannelKey, StoreKey, ProductKey,	PromotionKey, UnitCost,	UnitPrice, SalesQuantity, ReturnQuantity, ReturnAmount,	DiscountQuantity, DiscountAmount, TotalCost, SalesAmount)
select
	DateKey,
	channelKey,
	StoreKey,
	ProductKey,
	PromotionKey,
	UnitCost,
	UnitPrice,
	SalesQuantity,
	ReturnQuantity,
	ReturnAmount,
	DiscountQuantity,
	DiscountAmount,
	TotalCost,
	SalesAmount
from ContosoRetailDW..FactSales