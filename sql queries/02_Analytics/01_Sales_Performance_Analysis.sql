/* 
Sales Performance Analysis
- Overall Sales Trends: Analyze total sales over time
- Sales by Region and Store: Sales performance across different regions, cities and stores
- Sales by Product: Identify the best-selling products, subcategories, and categories.
- Sales Channels: Analyze the performance of different sales channels 
*/

use ContosoRetail

-- Overall Sales Trends
select
    [Year],
    MONTH(d.DateKey) as Month,
    [Quarter],
    SUM(SalesAmount) as TotalSales
from FactSales f
join DimDate d 
on f.DateKey = d.DateKey
group by [Year], MONTH(d.DateKey), [Quarter]
order by [Year], [Month]

-- Sales by Region and Store
select 
    RegionCountryName,
    CityName,
    StoreName,
    SUM(SalesAmount) as TotalSales
FROM FactSales f 
join DimStore s
on f.StoreKey = s.StoreKey
join DimGeography g
on s.GeographyKey = g.GeographyKey
group by RegionCountryName, CityName, StoreName

-- Overall sales by Products
select 
    ProductName,
    ProductSubcategoryName,
    ProductCategoryName,
    SUM(SalesAmount) as TotalSales
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
join DimProductSubcategory s 
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
join DimCategory c 
on s.ProductCategoryKey = c.ProductCategoryKey
group by ProductName, ProductSubcategoryName, ProductCategoryName

-- Sales by Products
select 
    ProductName,
    SUM(SalesAmount) as TotalSales
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
group by ProductName
order by TotalSales DESC

-- Sales by ProductSubcategory
select 
    ProductSubcategoryName,
    SUM(SalesAmount) as TotalSales
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
join DimProductSubcategory s 
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
group by ProductSubcategoryName
order by TotalSales DESC

-- Sales by ProductCategory
select 
    ProductCategoryName,
    SUM(SalesAmount) as TotalSales
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
join DimProductSubcategory s 
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
join DimCategory c 
on s.ProductCategoryKey = c.ProductCategoryKey
group by ProductCategoryName
order by TotalSales DESC

-- Sales Channels
select 
    ChannelName,
    SUM(SalesAmount) as TotalSales
from FactSales f
join DimChannel c 
on f.ChannelKey = c.ChannelKey
group by ChannelName
order by TotalSales DESC