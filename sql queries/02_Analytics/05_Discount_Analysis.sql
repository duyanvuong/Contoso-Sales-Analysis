use ContosoRetail

/*
Discount Analysis
- Sales, Profit, Average Profit Margin comparison between Discount and Non-Discount product
*/

-- Discount Analysis

-- Incremental Sales by top sales performing product

/*
Incremental sales is a metric that measures the difference between sales made during a promotion and the sales that would have occurred without the promotion. 
It's a key performance indicator (KPI) that helps determine the effectiveness of a marketing or sales campaign
*/

with discount_product as (
	select  
		ProductName,
		SUM(SalesAmount) as TotalSales_Discount
	from FactSales f
	join DimProduct p
	on f.ProductKey = p.ProductKey
	where DiscountAmount > 0
	group by ProductName
), non_discount as (
	select  
		ProductName,
		SUM(SalesAmount) as TotalSales_non_Discount
	from FactSales f
	join DimProduct p
	on f.ProductKey = p.ProductKey
	where DiscountAmount = 0
	group by ProductName
), sales_diff as (
	select 
		d.ProductName,
		TotalSales_Discount,
		TotalSales_non_Discount,
		TotalSales_Discount - TotalSales_non_Discount as Discount_Net_Impact
	from discount_product d
	join non_discount n
	on d.ProductName = n.ProductName
)
	select 
		*,
		FORMAT(Discount_Net_Impact / TotalSales_Discount, 'p') as Discount_Net_Impact_pct
	from sales_diff
	order by TotalSales_Discount DESC

;

-- Discount Net Impact by seasonal

with sales_data as (
	select 
		YEAR(DateKey) as Year,
		MONTH(DateKey) as Month,
		SUM(CASE WHEN DiscountAmount > 0 THEN SalesAmount ELSE 0 END) as TotalSales_Discount,
		SUM(CASE WHEN DiscountAmount = 0 THEN SalesAmount ELSE 0 END) as TotalSales_Non_Discount
	from FactSales
	group by YEAR(DateKey), MONTH(DateKey)
)
	select
		*,
		TotalSales_Discount - TotalSales_Non_Discount as Discount_Net_Impact
	from sales_data
	order by [Year], [Month]

;

-- Discount Net Impact in every continent, country, cities
with sales_data as (
	select 
		ContinentName as Continent,
		SUM(CASE WHEN DiscountAmount > 0 THEN SalesAmount ELSE 0 END) as Sales_Discount,
		SUM(CASE WHEN DiscountAmount = 0 THEN SalesAmount ELSE 0 END) as Sales_Non_Discount
	from FactSales f 
	join DimStore s 
	on f.StoreKey = s.StoreKey
	join DimGeography g 
	on s.GeographyKey = g.GeographyKey
	group by ContinentName
)
	select 
		*,
		Sales_Discount - Sales_Non_Discount as Discount_Net_Impact
	from sales_data

;

with sales_data as (
	select 
		RegionCountryName as Country,
		SUM(CASE WHEN DiscountAmount > 0 THEN SalesAmount ELSE 0 END) as Sales_Discount,
		SUM(CASE WHEN DiscountAmount = 0 THEN SalesAmount ELSE 0 END) as Sales_Non_Discount
	from FactSales f 
	join DimStore s 
	on f.StoreKey = s.StoreKey
	join DimGeography g 
	on s.GeographyKey = g.GeographyKey
	group by RegionCountryName
)
	select 
		*,
		Sales_Discount - Sales_Non_Discount as Discount_Net_Impact
	from sales_data

;

with sales_data as (
	select 
		CityName as cities,
		SUM(CASE WHEN DiscountAmount > 0 THEN SalesAmount ELSE 0 END) as Sales_Discount,
		SUM(CASE WHEN DiscountAmount = 0 THEN SalesAmount ELSE 0 END) as Sales_Non_Discount
	from FactSales f 
	join DimStore s 
	on f.StoreKey = s.StoreKey
	join DimGeography g 
	on s.GeographyKey = g.GeographyKey
	group by CityName
)
	select 
		*,
		Sales_Discount - Sales_Non_Discount as Discount_Net_Impact
	from sales_data


;

-- Total PROFIT comparison between Discount and Non-Discount product
with discount_product as (
	select  
		ProductName,
		SUM(SalesAmount) - SUM(TotalCost) as TotalProfit_Discount
	from FactSales f
	join DimProduct p
	on f.ProductKey = p.ProductKey
	where DiscountAmount > 0
	group by ProductName
), non_discount as (
	select  
		ProductName,
		SUM(SalesAmount) - SUM(TotalCost) as TotalProfit_non_Discount
	from FactSales f
	join DimProduct p
	on f.ProductKey = p.ProductKey
	where DiscountAmount = 0
	group by ProductName
), profit_diff as (
	select 
		d.ProductName,
		TotalProfit_Discount,
		TotalProfit_non_Discount,
		TotalProfit_Discount - TotalProfit_non_Discount as ProfitDiff
	from discount_product d
	join non_discount n
	on d.ProductName = n.ProductName
)
	select
		*,
		FORMAT(ProfitDiff / TotalProfit_Discount, 'p') as ProfitDiff_pct
	from profit_diff

;

-- AVG profit margin comparison between discount and non-discount
with profit_margin_discount as (
	select
		ProductName,
		(SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount) as ProfitMargin_Discount
	from FactSales f
	join DimProduct p
	on f.ProductKey = p.ProductKey
	where DiscountAmount > 0
	group by ProductName
), profit_margin_non_discount as (
	select
		ProductName,
		(SUM(SalesAmount) - SUM(TotalCost)) / SUM(SalesAmount) as ProfitMargin_Non_discount
	from FactSales f
	join DimProduct p
	on f.ProductKey = p.ProductKey
	where DiscountAmount = 0
	group by ProductName
), profit_margin_total as (
	select
		d.ProductName,
		ProfitMargin_Discount,
		ProfitMargin_Non_discount
	from profit_margin_discount d
	join profit_margin_non_discount nd
	on d.ProductName = nd.ProductName
)
	select
		FORMAT(AVG(ProfitMargin_Discount), 'p') as AVG_ProfitMargin_Discount,
		FORMAT(AVG(ProfitMargin_Non_discount), 'p') as AVG_ProfitMargin_Non_discount
	from profit_margin_total