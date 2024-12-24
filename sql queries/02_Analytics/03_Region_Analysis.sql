use ContosoRetail

/*
1. What are the sales and profit in different region ?
- Calculate sales, profit and profit margin for each continent
- Breakdown in Country and City
*/

-- Sales, Profit by Continent

select
	ContinentName as Continent,
	SUM(SalesAmount) as TotalSales,
	SUM(SalesAmount) - SUM(TotalCost) as TotalProfit,
    FORMAT((SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount), 'p') as ProfitMargin
from FactSales f
join DimStore s
on f.StoreKey = s.StoreKey
join DimGeography g
on g.GeographyKey = s.GeographyKey
group by ContinentName
order by TotalSales DESC

-- Sales and profit in Country

select
    RegionCountryName as Country,
    SUM(SalesAmount) as TotalSales,
    SUM(SalesAmount) - SUM(TotalCost) as TotalProfit,
    FORMAT((SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount), 'p') as ProfitMargin
from FactSales f 
join DimStore s 
on f.StoreKey = s.StoreKey
join DimGeography g 
on g.GeographyKey = s.GeographyKey
group by RegionCountryName
order by TotalProfit, TotalSales DESC

-- City

select
    CityName as City,
    SUM(SalesAmount) as TotalSales,
    SUM(SalesAmount) - SUM(TotalCost) as TotalProfit,
    FORMAT((SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount), 'p') as ProfitMargin
from FactSales f 
join DimStore s 
on f.StoreKey = s.StoreKey
join DimGeography g 
on g.GeographyKey = s.GeographyKey
group by CityName
order by TotalProfit, TotalSales DESC


/*
2. What are the return rates in each Continent, Country and City ?
- Identify orders that have return products
- Calculate the Return rates
- Break down into Country and City
*/

-- Return rates in each Continent
with total_quantity as (
    select
        ContinentName as Continent,
        SUM(CASE WHEN ReturnQuantity = 0 THEN 0 ELSE ReturnQuantity END) as ReturnQuantity, -- Identify orders that have return products
        SUM(SalesQuantity) as TotalQuantity
    from FactSales f 
    join DimStore s 
    on f.StoreKey = s.StoreKey
    join DimGeography g 
    on g.GeographyKey = s.GeographyKey
    group by ContinentName
)
    select 
        *,
        FORMAT(ReturnQuantity * 1.0 / TotalQuantity, 'p') as ReturnRates -- Calculate the Return rates
    from total_quantity

;

-- Return rates in Countries

with total_quantity as (
    select
        RegionCountryName as Countries,
        SUM(CASE WHEN ReturnQuantity = 0 THEN 0 ELSE ReturnQuantity END) as ReturnQuantity, -- Identify orders that have return products
        SUM(SalesQuantity) as TotalQuantity
    from FactSales f 
    join DimStore s 
    on f.StoreKey = s.StoreKey
    join DimGeography g 
    on g.GeographyKey = s.GeographyKey
    group by RegionCountryName
)
    select 
        *,
        FORMAT(ReturnQuantity * 1.0 / TotalQuantity, 'p') as ReturnRates -- Calculate the Return rates
    from total_quantity

;

-- Return rates in Cities

with total_quantity as (
    select
        CityName as Cities,
        SUM(CASE WHEN ReturnQuantity = 0 THEN 0 ELSE ReturnQuantity END) as ReturnQuantity, -- Identify orders that have return products
        SUM(SalesQuantity) as TotalQuantity
    from FactSales f 
    join DimStore s 
    on f.StoreKey = s.StoreKey
    join DimGeography g 
    on g.GeographyKey = s.GeographyKey
    group by CityName
)
    select 
        *,
        FORMAT(ReturnQuantity * 1.0 / TotalQuantity, 'p') as ReturnRates -- Calculate the Return rates
    from total_quantity