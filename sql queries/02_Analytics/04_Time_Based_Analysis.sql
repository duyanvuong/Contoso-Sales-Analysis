/*
Time-Based Analysis
- Seasonality analysis (Monthly)
- Promotion effectiveness overtime by promotion name
- Year-over-Year and Month-over-Month growth
*/

use ContosoRetail

-- Seaonality analysis: Uncover seasonal patterns
select 
    YEAR(DateKey) as Year,
    MONTH(DateKey) as Month,
    SUM(SalesAmount) as TotalSales,
    SUM(SalesQuantity) as TotalQuantity,
    SUM(TotalCost) as TotalCost,
    SUM(SalesAmount) - SUM(TotalCost) as TotalProfit,
    ProfitMargin = ((SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount)) * 100,
    ReturnRates = (SUM(ReturnQuantity)*1.0 / SUM(SalesQuantity)) * 100
from FactSales
group by YEAR(DateKey), MONTH(DateKey)
order by YEAR(DateKey), MONTH(DateKey)

-- Promotion effectiveness overtime by promotion name
select 
    DATEPART(QUARTER, DateKey) as [Quarter],
    PromotionName,
    SUM(SalesAmount) as TotalSales,
    SUM(DiscountAmount) as TotalDiscountAmount
from FactSales f 
join DimPromotion p on f.PromotionKey = p.PromotionKey
where PromotionName != 'No Discount'
group by DATEPART(QUARTER, DateKey), PromotionName
order by [Quarter]

-- Month-over-Month Growth
with current_sales as (
    select 
        YEAR(DateKey) as Year,
        MONTH(DateKey) as Month,
        SUM(SalesAmount) as TotalSales
    from FactSales
    group by YEAR(DateKey), MONTH(DateKey)
), prev_month_sales as (
    select 
        *,
        LAG(TotalSales) OVER (ORDER BY [Year], [Month]) as PreviousMonthSales
    from current_sales
)
    select 
        Year,
        Month,
        TotalSales,
        ISNULL(PreviousMonthSales, 0) as PreviousMonthSales,
        MoM_Growth = ISNULL(FORMAT((TotalSales - PreviousMonthSales) / PreviousMonthSales, 'p'), FORMAT(0,'p'))
    from prev_month_sales
;

-- Year-over-Year growth
with current_sales as (
    select 
        YEAR(DateKey) as Year,
        SUM(SalesAmount) as TotalSales
    from FactSales
    group by YEAR(DateKey)
), prev_month_sales as (
    select 
        *,
        LAG(TotalSales) OVER (ORDER BY [Year]) as PreviousYearSales
    from current_sales
)
    select 
        Year,
        TotalSales,
        ISNULL(PreviousYearSales, 0) as PreviousYearSales,
        YoY_Growth = ISNULL(FORMAT((TotalSales - PreviousYearSales) / PreviousYearSales, 'p'), FORMAT(0,'p'))
    from prev_month_sales