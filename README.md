# SQL-Datawarehouse-Analytics-mini_project
Survey Monkey Data Warehouse Project
A comprehensive SQL data warehouse implementation demonstrating medallion architecture and advanced data transformation techniques using real survey data.
Overview
This project transforms raw Survey Monkey data through a three-tier medallion architecture (Bronze → Silver → Gold) while providing educational insights into SQL data transformation methods. The primary educational focus compares UNPIVOT vs CROSS APPLY techniques, demonstrating real-world data integrity considerations.
Key Learning Objectives

Medallion Architecture: Implement bronze, silver, and gold data layers
Data Transformation: Compare SQL methods for unpivoting wide survey data
Data Integrity: Understand the impact of NULL handling on analysis results
Real-world Complexity: Work with messy column names and data quality issues
SQL vs Python: Demonstrate scenarios where pandas outperforms SQL transformations

Educational Highlight: UNPIVOT vs CROSS APPLY
This project demonstrates a critical data engineering concept through actual results:

UNPIVOT method: 9,664 rows (silently excludes NULL values)
CROSS APPLY method: 17,028 rows (preserves complete data)

Data Loss Impact: 43% of survey response data is lost when using UNPIVOT, affecting response rate calculations and statistical validity.
Repository Structure
survey-monkey-data-warehouse/
│
├── README.md                           # Project overview and setup instructions
├── LICENSE                             # License information  
├── .gitignore                         # Files to ignore in version control
│
├── docs/                              # Project documentation and data files
│   ├── edited_survey_monkey_dataset.csv     # Main survey response data (source)
│   ├── question-subquestion.csv            # Question lookup reference table
│   ├── data_dictionary.md                  # Column definitions and metadata
│   └── project_overview.md                 # Architecture and design decisions
│
├── scripts/                           # SQL scripts organized by medallion architecture
│   │
│   ├── bronze/                        # Raw data ingestion layer (Stage 1)
│   │   ├── bronze_ddl.sql            # Database + schema + table creation
│   │   └── bronze_load_procedure.sql  # CSV bulk import procedures
│   │
│   ├── silver/                        # Data transformation layer (Stage 2)  
│   │   ├── silver_ddl.sql            # Normalized table structures
│   │   └── silver_load_procedure.sql  # CROSS APPLY transformation logic
│   │
│   └── gold/                          # Analytics layer (Stage 3)
│       └── gold_view.sql             # Business views with aggregations
│
├── tests/                             # Educational comparisons and validation
│   ├── UNPIVOT_vs_CROSS_APPLY.sql    # Method comparison (teaching focus)
│   └── data_quality_checks.sql        # Row count and integrity validation
│
└── analysis/                          # Research and exploration queries
    ├── survey_insights.sql            # Response pattern analysis
    └── statistical_analysis.sql       # Correlation and trend queries
Architecture Overview
Bronze Layer (Raw Data)

Purpose: Store unprocessed data exactly as received
Tables: bronze.survey_responses, bronze.questions_import
Characteristics: Preserves original column names, data types, and Survey Monkey quirks

Silver Layer (Cleaned Data)

Purpose: Normalized, cleaned data ready for analysis
Transformation: Wide format → Long format using CROSS APPLY
Key Feature: Preserves NULL values for complete data integrity

Gold Layer (Analytics Ready)

Purpose: Business-ready views with aggregated metrics
Features: Response rates, answer frequencies, statistical summaries
Usage: Direct consumption by BI tools and reporting applications

Technical Features
Data Transformation Highlights

Survey Unpivoting: Converts 79+ question columns into normalized rows
Demographic Standardization: Clean column names and consistent formatting
Question Enrichment: Joins response codes with descriptive question text
NULL Preservation: Maintains survey completion patterns for analysis

Production-Ready Features

Error Handling: Comprehensive TRY-CATCH blocks with detailed error reporting
Performance Monitoring: Execution timing for each transformation step
Progress Tracking: Real-time feedback during data loading operations
Modular Design: Independent scripts for easy maintenance and updates

Setup Instructions
Prerequisites

SQL Server (Express or higher)
SQL Server Management Studio (SSMS)
Survey data CSV files (provided in /docs/ folder)

Installation Steps

Clone Repository

bash   git clone https://github.com/your-username/survey-monkey-data-warehouse.git
   cd survey-monkey-data-warehouse

Database Setup

sql   -- Run in SSMS
   -- Execute: scripts/bronze/bronze_ddl.sql

Configure File Paths

Edit scripts/bronze/bronze_load_procedure.sql
Update CSV file paths on lines 66 and 82 to match your local file locations


Load Data

sql   -- Execute: scripts/bronze/bronze_load_procedure.sql
   EXEC bronze.load_bronze;

Transform Data

sql   -- Execute: scripts/silver/silver_ddl.sql
   -- Execute: scripts/silver/silver_load_procedure.sql
   EXEC silver.load_silver;

Create Analytics Views

sql   -- Execute: scripts/gold/gold_view.sql
   EXEC gold.ordered_survey_response;
Usage Examples
Compare Transformation Methods
sql-- Run the educational comparison
-- Execute: tests/UNPIVOT_vs_CROSS_APPLY.sql

-- Observe row count differences:
-- UNPIVOT: 9,664 rows (data loss)
-- CROSS APPLY: 17,028 rows (complete data)
Analyze Survey Results
sql-- View response rates by question
SELECT Question, Respondents, 
       ROUND(Respondents * 100.0 / 216, 2) AS response_rate_pct
FROM gold.joined_survey_reponse
WHERE Question IS NOT NULL
GROUP BY Question, Respondents
ORDER BY response_rate_pct DESC;
Examine Answer Patterns
sql-- Most common answers across all questions
SELECT Answer, COUNT(*) as frequency
FROM gold.joined_survey_reponse  
WHERE Answer IS NOT NULL
GROUP BY Answer
ORDER BY frequency DESC;
Educational Applications
Data Engineering Concepts

ETL Pipeline Design: Bronze → Silver → Gold progression
Data Quality Management: Handling missing values and data validation
Schema Evolution: From wide survey format to normalized analytical structure
Performance Optimization: Bulk loading, indexing considerations

SQL Advanced Techniques

CROSS APPLY with VALUES: Manual unpivoting with full control
Dynamic SQL: Working with complex column structures
Window Functions: Analytical calculations and rankings
Stored Procedures: Production-ready automation and error handling

Business Intelligence Concepts

Survey Analysis: Response rates, completion patterns, demographic insights
Data Modeling: Star schema principles for analytical queries
Reporting Preparation: Creating business-friendly data structures

Key Insights and Findings
Data Transformation Results

Total Survey Responses: 216 respondents
Questions per Survey: 79+ individual question/sub-question combinations
Data Preservation: CROSS APPLY maintains 76% more data than UNPIVOT
Processing Performance: Complete ETL pipeline executes in under 30 seconds

Business Intelligence Outcomes

Response Rate Analysis: Identify question completion patterns
Demographic Insights: Cross-tabulate responses by division, generation, tenure
Survey Quality Metrics: Measure engagement and completion rates
Statistical Foundation: Clean data ready for advanced analytics

Future Enhancements
Planned Features

Incremental Loading: Delta processing for new survey responses
Data Validation: Automated quality checks and anomaly detection
Advanced Analytics: Statistical modeling and predictive analysis
Dashboard Integration: Power BI/Tableau connectivity

Potential Extensions

Multi-Survey Support: Handle multiple survey datasets
Historical Tracking: Maintain survey response history over time
Advanced Transformations: Machine learning feature engineering
Real-time Processing: Stream processing for live survey data

Contributing
Contributions are welcome! Please feel free to submit pull requests or open issues for:

Additional analytical queries
Performance optimizations
Documentation improvements
Educational enhancements

License
This project is licensed under the MIT License - see the LICENSE file for details.
Acknowledgments

Survey Monkey for providing realistic survey data structure
SQL Server community for transformation technique insights
Data engineering best practices from medallion architecture implementations
