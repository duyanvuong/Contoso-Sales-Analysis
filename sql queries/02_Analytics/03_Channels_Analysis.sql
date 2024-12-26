use ContosoRetail

/*
1. HOW ARE SALES, PROFIT, PROFIT MARGIN IN EACH CHANNELS
- Calculate sales, profit, profit margin
- Group by channels
*/

select
	ChannelName,
	SUM(SalesAmount) as TotalSales,
	SUM(SalesAmount) - SUM(TotalCost) as TotalProfit,
    FORMAT((SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount), 'p') as ProfitMargin
from FactSales f
join DimChannel c
on f.ChannelKey = c.ChannelKey
group by ChannelName
order by TotalSales DESC, TotalProfit DESC