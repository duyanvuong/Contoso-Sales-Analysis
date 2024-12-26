use ContosoRetail
;
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