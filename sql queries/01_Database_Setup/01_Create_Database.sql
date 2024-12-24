create database ContosoRetail
use ContosoRetail

-- DimDate

create table DimDate (
	DateKey datetime primary key,
	Year int NOT NULL, -- CalendarYear
	MonthName nvarchar(20) NOT NULL, -- CalendarMonthLabel
	Day int NOT NULL, -- DAY(DateKey)
	Quarter nvarchar(20) NOT NULL -- CalendarQuarterLabel
)

-- DimChannel

create table DimChannel (
	ChannelKey int IDENTITY(1,1) primary key,
	ChannelName nvarchar(20) NOT NULL
)

-- DimPromotion

create table DimPromotion (
	PromotionKey int IDENTITY(1,1) primary key,
	PromotionName nvarchar(100),
	DiscountPct float NOT NULL
)

-- DimGeography

create table DimGeography (
	GeographyKey int primary key,
	ContinentName nvarchar(50) NOT NULL,
	CityName nvarchar(100),
	StateProvinceName nvarchar(100),
	RegionCountryName nvarchar(100)
)

-- DimStore

create table DimStore (
	StoreKey int primary key,
	GeographyKey int foreign key references DimGeography(GeographyKey) NOT NULL,
	StoreType nvarchar(15),
	StoreName nvarchar(100) NOT NULL
)

-- DimProductCategory

create table DimCategory (
	ProductCategoryKey int IDENTITY(1,1) primary key,
	ProductCategoryName nvarchar(30) NOT NULL
)

-- DimProductSubcategory

create table DimProductSubcategory (
	ProductSubcategoryKey int primary key,
	ProductSubcategoryName nvarchar(50),
	ProductCategoryKey int foreign key references DimCategory(ProductCategoryKey) NOT NULL
)

-- DimProduct

create table DimProduct (
	ProductKey int IDENTITY(1,1) primary key,
	ProductName nvarchar(500),
	ProductSubcategoryKey int references DimProductSubcategory(ProductSubcategoryKey) NOT NULL
)

-- FactSales

create table FactSales (
	SalesKey int IDENTITY(1,1) primary key, -- IDENTITY(1,1) is for AUTO INCREMENT
	DateKey datetime NOT NULL,
	ChannelKey int NOT NULL,
	StoreKey int NOT NULL,
	ProductKey int NOT NULL,
	PromotionKey int NOT NULL,
	UnitCost money NOT NULL,
	UnitPrice money NOT NULL,
	SalesQuantity int NOT NULL,
	ReturnQuantity int NOT NULL,
	ReturnAmount money,
	DiscountQuantity int,
	DiscountAmount money,
	TotalCost money NOT NULL,
	SalesAmount money NOT NULL
)

-- ADD FOREIGN KEY FOR FactSales

alter table FactSales
add foreign key (DateKey) references DimDate(DateKey)

alter table FactSales
add foreign key (ChannelKey) references DimChannel(ChannelKey)

alter table FactSales
add foreign key (StoreKey) references DimStore(StoreKey)

alter table FactSales
add foreign key (ProductKey) references DimProduct(ProductKey)

alter table FactSales
add foreign key (PromotionKey) references DimPromotion(PromotionKey)