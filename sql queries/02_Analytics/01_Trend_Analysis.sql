use ContosoRetail

/*
HOW SALES (REVENUE), PROFIT, PROFIT MARGIN ARE TRENDED OVER YEAR ?
- Calculate total sales to see how sales are trended by each year
- Break total sales down to each months by every year
- Calculate the Difference and Growth Rate of Sales and Profit between the same 2 months from each year
*/

/*
SALES TREND
*/

-- Sales trend by each Year

select 
	YEAR(DateKey) as Year,
	SUM(SalesAmount) as TotalSales
from FactSales
group by YEAR(DateKey)
order by YEAR(DateKey) ASC

-- Sales trend break down to each months by every year, calculate Sales Difference and Sales Growth Rate
-- The result has NULL VALUES for the first year (2022) because there are no records from the previous year (2021)

select 
	*,
	FORMAT(SalesDifference/TotalSales,'p') as SalesGrowthRate
from (
	select
		YEAR(DateKey) as Year,
		MONTH(DateKey) as Month,
		SUM(SalesAmount) as TotalSales,
		LAG(SUM(SalesAmount), 12) OVER (ORDER BY YEAR(DateKey), MONTH(DateKey)) as TotalSales_SamePeriodLastYear,
		SUM(SalesAmount) - LAG(SUM(SalesAmount), 12) OVER (ORDER BY YEAR(DateKey), MONTH(DateKey)) as SalesDifference
	from 
		FactSales
	group by 
		YEAR(DateKey), MONTH(DateKey)
) as sales_diff
order by 
	Year, Month

/*
PROFIT TREND
Profit = TotalSales - TotalCost
*/

-- Profit trend by each Year

select 
	YEAR(DateKey) as Year,
	SUM(SalesAmount) - SUM(TotalCost) as Profit
from 
	FactSales
group by 
	YEAR(DateKey)
order by 
	YEAR(DateKey)

-- Profit trend break down to each months by every year, calculate Profit Difference and Profit Growth Rate

select 
	*,
	FORMAT(ProfitDifference / TotalProfit, 'p') as ProfitGrowthRate
from (
	select
		YEAR(DateKey) as Year,
		MONTH(DateKey) as Month,
		SUM(SalesAmount) - SUM(TotalCost) as TotalProfit,
		LAG(SUM(SalesAmount) - SUM(TotalCost), 12) OVER (ORDER BY YEAR(DateKey), MONTH(DateKey)) as TotalProfit_SamePeriodLastYear,
		SUM(SalesAmount) - LAG(SUM(SalesAmount), 12) OVER (ORDER BY YEAR(DateKey), MONTH(DateKey)) as ProfitDifference
	from 
		FactSales
	group by 
		YEAR(DateKey), MONTH(DateKey)
) as profit_diff
order by
	Year, Month

/*
COGs TREND
*/

-- Yearly COGs Trend
select 
	YEAR(DateKey) as Year,
	SUM(TotalCost) - SUM(DiscountAmount) as COGs
from FactSales
group by YEAR(DateKey)
order by [Year]

-- Monthly COGs Trend in every year
select
	YEAR(DateKey) as Year,
	MONTH(DateKey) as Month,
	SUM(TotalCost) - SUM(DiscountAmount) as COGs
from FactSales
group by YEAR(DateKey), MONTH(DateKey)
order by [Year], [Month]

/*
PROFIT MARGIN TREND
*/

-- Profit margin

select 
	YEAR(DateKey) as Year,
	FORMAT((SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount), 'p') as ProfitMargin
from FactSales
group by YEAR(DateKey)
order by Year

-- Montly profit margin

select
	YEAR(DateKey) as Year,
	MONTH(DateKey) as Month,
	FORMAT((SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount), 'p') as ProfitMargin
from FactSales
group by YEAR(DateKey), MONTH(DateKey)
order by [Year], [Month]