use ContosoRetail

/*
PRODUCT ANALYSIS
1. Top performing products (Sales, Profit, Quantity)
2. Return analysis
3. Seasonal trends
4. Discount impact: Sales comparison between discount and non-discount
*/

/*
1. Top performing products (Sales, Profit, Quantity)
*/

-- Top performing products by SalesAmount
select top 10
    ProductName,
    SUM(SalesAmount) as TotalSales
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
group by ProductName
order by TotalSales DESC

-- Top performing products by Profit
select top 10
    ProductName,
    SUM(SalesAmount) - SUM(TotalCost) as TotalProfit
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
group by ProductName
order by TotalProfit DESC

-- Top performing products by SalesQuantity
select top 10 
    ProductName,
    SUM(SalesQuantity) as TotalQuantity
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
group by ProductName
order by TotalQuantity DESC


/*
2. Return analysis
*/
-- Total returns by product

select 
    ProductName,
    SUM(ReturnAmount) as ReturnAmount,
    SUM(ReturnQuantity) as ReturnQuantity
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
group by ProductName

-- Return rates
select 
	ProductName,
	TotalQuantity,
	FORMAT(TotalReturns * 1.0 / TotalQuantity,'p') as ProductReturnRates
from (
	select  
		ProductName,
		SUM(CASE WHEN ReturnQuantity = 0 THEN 0 ELSE ReturnQuantity END) as TotalReturns,
		SUM(SalesQuantity) as TotalQuantity
	from FactSales f
	join DimProduct p
	on f.ProductKey = p.ProductKey
	group by ProductName
) as quantity_returns
order by ProductReturnRates DESC


/*
3. Seasonal Trends
*/

select 
	ProductName,
	YEAR(DateKey) as Year,
	MONTH(DateKey) as Month,
	SUM(SalesAmount) as TotalSales
from FactSales f  
join DimProduct p 
on f.ProductKey = p.ProductKey
group by ProductName, YEAR(DateKey), MONTH(DateKey)
order by [Year], [Month]


/*
4. Discount impact: Sales comparison between discount and non-discount
*/

select 
	ProductName,
	SUM(DiscountAmount) as TotalDiscounts,
	SUM(SalesAmount) as TotalSales,
	COUNT(*) as TotalTransactions
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
group by ProductName

;

with product_sales_with_discount as (
	select
		ProductName,
		SUM(SalesAmount) as TotalSales_WithoutDiscount
	from FactSales f 
	join DimProduct p 
	on f.ProductKey = p.ProductKey
	where DiscountAmount = 0
	group by ProductName
), product_sales_without_discount as (
	select
		ProductName,
		SUM(SalesAmount) as TotalSales_WithDiscount
	from FactSales f 
	join DimProduct p 
	on f.ProductKey = p.ProductKey
	where DiscountAmount > 0
	group by ProductName
)
	select 
		wd.ProductName,
		TotalSales_WithDiscount,
		TotalSales_WithoutDiscount,
		TotalSales_WithDiscount - TotalSales_WithoutDiscount as IncrementalSales
	from product_sales_with_discount wd 
	join product_sales_without_discount wod 
	on wd.ProductName = wod.ProductName