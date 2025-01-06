use ContosoRetail
;

-- DataFrame
create VIEW [ContosoRetail_df] as 
select 
    SalesKey,
    DateKey,
    ChannelName,
    StoreName,
    ContinentName,
    RegionCountryName as Country,
    CityName as City,
    ProductName,
    ProductCategoryName as ProductCategory,
    PromotionName,
    UnitCost,
    UnitPrice,
    SalesQuantity,
    ReturnQuantity,
    ReturnAmount,
    DiscountQuantity,
    DiscountAmount,
    TotalCost,
    SalesAmount
from FactSales f 
join DimChannel c 
on f.ChannelKey = c.ChannelKey
join DimStore s 
on f.StoreKey = s.StoreKey
join DimGeography g 
on s.GeographyKey = g.GeographyKey
join DimProduct pro 
on pro.ProductKey = f.ProductKey
join DimProductSubcategory sub 
on sub.ProductSubcategoryKey = pro.ProductSubcategoryKey
join DimCategory cat 
on cat.ProductCategoryKey = sub.ProductCategoryKey
join DimPromotion promo 
on promo.PromotionKey = f.PromotionKey

-- Discount effectiveness
create view [Discount_Effectiveness] as
select 
    ProductName,
    DiscountPct,
	CASE
		WHEN DiscountPct >= 0 and DiscountPct < 0.1 THEN '0% - 10%'
		WHEN DiscountPct >= 0.1 and DiscountPct < 0.15 THEN '10% - 15%'
		ELSE '15% - 20%'
	END as DiscountTier,
    DiscountQuantity,
    DiscountAmount,
    SalesAmount,
    SalesQuantity,
    TotalCost
from FactSales f 
join DimPromotion p on f.PromotionKey = p.PromotionKey
join DimProduct pro on f.ProductKey = pro.ProductKey

-- Regional revenue
create view [regional_revenue] as
select
	ContinentName as Continent,
	RegionCountryName as Country,
	CityName as City,
	SalesAmount,
	TotalCost,
	SalesQuantity,
	ReturnAmount,
	ReturnQuantity,
	DiscountAmount
from FactSales f 
join DimStore s on f.StoreKey = s.StoreKey
join DimGeography g on g.GeographyKey = s.GeographyKey