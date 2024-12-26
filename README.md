# Contoso Sales Analysis
This project leverages the ContosoRetailDW database by Microsoft, focusing on the FactSales table to analyze retail sales data. The objective is to uncover actionable insights by exploring sales performance, customer purchasing behavior, and trends over time. By integrating key dimensions such as products, geography, and dates, the analysis provides a comprehensive understanding of business performance. The outcomes of this project include interactive visualizations, data-driven dashboards, and valuable metrics to support strategic decision-making in retail operations.

# Table of Content
## [Database setup locally and EDA using SQL Server](/sql%20queries/Database_Setup_EDA_README.md)

- Database set up
    - Restore the database by importing the .bak file downloaded from Microsoft [website](https://www.microsoft.com/en-us/download/details.aspx?id=18279)
    - Identify which tables am I going to use in the Data Warehouse
    - Create a local database (new database), extract data from Data Warehouse
    - Establish relationships between tables (dimensions) to create data models

- Data cleaning
    - Check for missing values in each table
    - Fill out the missing values if it neccessary, if it doesn't, drop all missing values

- Sales EDA using SQL Server
    - Sales Performance Analysis
    - Regional Performance
    - Customer Behavior
    - Time - based Trends
    - Promotion Effectiveness
    - Profitability Analysis

## [Visualizing data using Python](/python/)

- Core libraries: `Pandas`, `Matplotlib`, `Seaborn`
- Conect to the database using SQLAlchemy
- Visualizing data from views created from SQL Server