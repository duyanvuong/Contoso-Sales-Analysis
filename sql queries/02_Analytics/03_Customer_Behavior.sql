/*
Customer Behavior Analysis
- Discount Effectiveness: Examine the impact of discounts on sales performance
- Return Analysis: Return rates by product, geography
- Seasonality Trend
*/

use ContosoRetail

/*
Discount Effectiveness
*/

-- How Discounts impact profit

with discounted_profit as (
    select
        ProductCategoryName,
        SUM(SalesAmount) - SUM(TotalCost) as Discount_Profit
    from FactSales f 
    join DimProduct p 
    on f.ProductKey = p.ProductKey
    join DimProductSubcategory s 
    on p.ProductSubcategoryKey = s.ProductSubcategoryKey
    join DimCategory c 
    on c.ProductCategoryKey = s.ProductCategoryKey
    where DiscountAmount > 0
    group by ProductCategoryName
), non_discounted_sales as (
    select
        ProductCategoryName,
        SUM(SalesAmount) - SUM(TotalCost) as Non_Discount_Profit
    from FactSales f 
    join DimProduct p 
    on f.ProductKey = p.ProductKey
    join DimProductSubcategory s 
    on p.ProductSubcategoryKey = s.ProductSubcategoryKey
    join DimCategory c 
    on c.ProductCategoryKey = s.ProductCategoryKey
    where DiscountAmount = 0
    group by ProductCategoryName
)
    select 
        d.ProductCategoryName,
        Discount_Profit,
        Non_Discount_Profit,
        IIF(Non_Discount_Profit < Discount_Profit, 'True', 'False') as Sales_Comparison
    from discounted_profit d 
    join non_discounted_sales n 
    on d.ProductCategoryName = n.ProductCategoryName
    order by Sales_Comparison DESC

-- Which promotions drive the highest sales or profits
select
    PromotionName,
    SUM(SalesAmount) as TotalSales,
    SUM(SalesAmount) - SUM(TotalCost) as TotalProfit
from FactSales f 
join DimPromotion p 
on f.PromotionKey = p.PromotionKey
group by PromotionName
order by TotalSales, TotalProfit DESC


/*
Return Rates Analysis
*/

select 
    ProductName,
    ProductSubcategoryName,
    ProductCategoryName,
    (SUM(ReturnQuantity)*1.0 / SUM(SalesQuantity)) * 100 as ReturnRates
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
join DimProductSubcategory s 
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
join DimCategory c 
on c.ProductCategoryKey = s.ProductCategoryKey
group by ProductName, ProductSubcategoryName, ProductCategoryName
order by ReturnRates DESC

select 
    ProductCategoryName,
    (SUM(ReturnQuantity)*1.0 / SUM(SalesQuantity)) * 100 as ReturnRates
from FactSales f 
join DimProduct p 
on f.ProductKey = p.ProductKey
join DimProductSubcategory s 
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
join DimCategory c 
on c.ProductCategoryKey = s.ProductCategoryKey
group by ProductCategoryName
order by ReturnRates DESC

;
/*
Seasonality
- There are no Customers Dimension, so I am going to use Purchasing Orders (Sales records in FactSales) for identifying seasonality purchasing pattern
*/

with discount_trend as (
    select
        YEAR(DateKey) as Year,
        MONTH(DateKey) as Month,
        SUM(SalesAmount) as Discount_Sales,
        Discount_Profit = SUM(SalesAmount) - SUM(TotalCost) 
    from FactSales
    where DiscountAmount > 0
    group by YEAR(DateKey), MONTH(DateKey)
    -- order by [Year], [Month]
), non_discount_trend as (
    select
        YEAR(DateKey) as Year,
        MONTH(DateKey) as Month,
        SUM(SalesAmount) as Non_Discount_Sales,
        Non_Discount_Profit = SUM(SalesAmount) - SUM(TotalCost) 
    from FactSales
    where DiscountAmount = 0
    group by YEAR(DateKey), MONTH(DateKey)
    -- order by [Year], [Month]
)
    select distinct
        d.Year,
        d.Month,
        Discount_Sales,
        Non_Discount_Sales,
        Discount_Profit,
        Non_Discount_Profit
    from discount_trend d 
    join non_discount_trend n 
    on d.Year = n.Year and d.Month = n.[Month]
    order by [Year], [Month]