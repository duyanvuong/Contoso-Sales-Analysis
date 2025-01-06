/*
Profitability Analysis
- Gross Profit Analysis
- Profitability by Product Category: Determine which product categories 
*/

use ContosoRetail

select 
    ProductName,
    ProductSubcategoryName,
    ProductCategoryName,
    YEAR(DateKey) as Year,
    MONTH(DateKey) as Month,
    SUM(SalesAmount) as TotalSales,
    SUM(TotalCost) as TotalCost,
    SUM(SalesQuantity) as SalesQuantity,
    TotalProfit = SUM(SalesAmount) - SUM(TotalCost),
    ProfitMargin = (SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount)
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
join DimProductSubcategory s 
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
join DimCategory c 
on s.ProductCategoryKey = c.ProductCategoryKey
group by ProductName, ProductSubcategoryName, ProductCategoryName, YEAR(DateKey), MONTH(DateKey)