# Coffee Shop Dashboard Project

This README provides an overview and detailed instructions for the Coffee Shop Dashboard Project, which is managed using Excel. The dashboard helps analyze transactions and visualize data efficiently, providing insights into sales and customer behavior in a coffee shop setting.

## Project Overview

The Coffee Shop Dashboard is a comprehensive tool designed to integrate and analyze transactional data, creating visualizations and reports. The project optimizes data processing using Excel's advanced features like Power Pivot, pivot tables, and slicers.

## Tools Used

- Microsoft Excel

## Tags

- Excel
- Dashboard
- Data Analysis
- Coffee Shop

## Key Features

- **Data Loading and Preprocessing:** Extract and transform raw transaction data to remove unnecessary details and format the data appropriately.
- **Column Transformations:** Add and modify columns to meet specific requirements, such as calculating the total bill.
- **Conditional Formatting:** Classify and format data based on conditions to enhance readability and insights.
- **Data Modeling:** Integrate processed data into a data model for efficient utilization in reports and visualizations.
- **Pivot Tables and Charts:** Create interactive tables and charts to represent data visually and highlight key metrics.
- **Dashboard Creation:** Compile all visual elements into a centralized, accessible dashboard page.

## Detailed Steps

1. **Data Import and Cleaning**
   - Load transaction data into Excel through the 'Get Data' feature within the Data tab.
   - Use the Navigator to clean and process the data, akin to Power BI operations.
   - Transform and add new columns based on specific conditions and requirements.
   - Ensure data consistency by verifying column types and cleaning data entries (e.g., trimming spaces, formatting text).

2. **Column Calculations**
   - Create conditional columns for product sizes (e.g., 'Lg' for large, 'Rg' for regular, 'Sm' for small) and replace these with standardized terms.
   - Calculate the 'Total Bill' by multiplying transaction quantities and unit prices.
   - Transform 'Transaction Time' to exclude the date and convert it to a proper time format.
   - Extract and add the 'Month' from transaction dates for temporal analysis.

3. **Data Model Integration**
   - Use the 'Close and Load To' function to add processed data to the data model, enabling its use across the project.
   - If data isn't added initially, revisit the Query tab for proper data load.

4. **Visualization Development**
   - Enable the 'MS Pivot' COM add-in through the Developer tab.
   - Utilize pivot tables from the data model to create dynamic tables and charts.
   - Build a dedicated dashboard page, arranging charts and tables neatly, applying color themes, and labeling elements clearly.
   - Incorporate slicers to allow dynamic adjustments and filtering across all charts.

5. **Protection and Security**
   - Apply password protection to the Excel sheet and key components to maintain data integrity and confidentiality.
  
## Challenges & Learnings

- **Challenges:** Effective data transformation and conditional formatting were essential to ensure data accuracy and visualization efficacy.
- **Learnings:** Mastery of Excel's advanced features like Power Pivot and slicers enhances capability in building intuitive and informative dashboards.

This project represents a complete solution for processing and visualizing coffee shop transaction data, offering actionable insights through a structured dashboard.
