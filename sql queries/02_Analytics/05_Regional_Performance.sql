/*
Regional Performance
- Identify top performance region from calculating renvenue by country, city
- Store types analysis: identify store types performance difference
*/

use ContosoRetail

-- Top performance region
select 
    RegionCountryName as Region,
    CityName as City,
    SUM(SalesAmount) as TotalSales,
    SUM(SalesQuantity) as TotalQuantity,
    SUM(SalesAmount) - SUM(TotalCost) as TotalProfit,
    ProfitMargin = ((SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount)) * 100
from FactSales f 
join DimStore s on f.StoreKey = s.StoreKey
join DimGeography g on s.GeographyKey = g.GeographyKey
group by RegionCountryName, CityName
order by TotalSales, TotalProfit, TotalQuantity DESC

-- Store types analysis
select 
    StoreType,
    SUM(SalesAmount) as TotalSales
from FactSales f 
join DimStore s on f.StoreKey = s.StoreKey
group by StoreType
order by TotalSales DESC