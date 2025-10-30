# Survey Monkey Data Analysis Pipeline

A comprehensive SQL Server data pipeline implementing a medallion architecture (Bronze-Silver-Gold) for transforming and analyzing Survey Monkey survey responses.

## 📋 Overview

This project demonstrates a robust ETL pipeline that transforms wide-format survey data into a normalized, analysis-ready format. It showcases best practices in data engineering including structured layering, error handling, and data quality preservation.

**Key Features:**
- 🏗️ **Medallion Architecture**: Clean separation of raw, transformed, and analytical data layers
- 🔄 **Automated ETL**: Stored procedures for repeatable data loading and transformation
- 📊 **Data Normalization**: Converts 79+ survey columns into a standardized long format
- ✅ **Data Integrity**: Preserves NULL values for complete survey response analysis
- ⚡ **Performance Optimized**: Uses BULK INSERT and efficient query patterns

## 🏛️ Architecture
```
┌─────────────────┐
│  Bronze Layer   │  Raw data ingestion from CSV files
│  (Raw Data)     │  • survey_responses
└────────┬────────┘  • questions_import
         │
         ▼
┌─────────────────┐
│  Silver Layer   │  Normalized transformation
│  (Cleaned)      │  • Unpivots wide format to long format
└────────┬────────┘  • Joins with question metadata
         │
         ▼
┌─────────────────┐
│   Gold Layer    │  Analytics-ready views
│  (Analytics)    │  • Aggregated metrics
└─────────────────┘  • Response statistics
```

## 🗂️ Database Schema

### Bronze Schema
- **`survey_responses`**: Raw survey data (216 respondents × 79+ questions)
- **`questions_import`**: Question text and metadata lookup table

### Silver Schema
- **`joined_survey_reponse`**: Normalized survey data with demographics and question text

### Gold Schema
- **`joined_survey_reponse`** (view): Analytics view with response counts and statistics
- **`ordered_survey_response`** (procedure): Ordered query results by question number

## 🚀 Getting Started

### Prerequisites
- SQL Server 2016 or later
- File system access for CSV import
- Appropriate database permissions

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/survey-monkey-pipeline.git
```

2. **Prepare your data files**
   - Place `edited_survey_monkey_dataset.csv` in an accessible location
   - Place `question-subquestion.csv` in the same directory

3. **Update file paths**
   
   Edit the file paths in `bronze.load_bronze` stored procedure (lines 66 and 82):
```sql
   FROM 'YOUR_PATH_HERE/edited_survey_monkey_dataset.csv'
```

4. **Run the setup scripts in order**
```sql
   -- 1. Database and table creation
   RUN: database_setup.sql
   
   -- 2. Bronze layer loading
   RUN: bronze_load.sql
   
   -- 3. Silver layer transformation
   RUN: silver_load.sql
   
   -- 4. Gold layer views and procedures
   RUN: gold_load.sql
```

### Quick Start
```sql
-- Execute complete pipeline
EXEC bronze.load_bronze;   -- Load raw data
EXEC silver.load_silver;   -- Transform data
EXEC gold.ordered_survey_response;  -- View analytics
```

## 📊 Data Transformation Process

### Wide to Long Format
The pipeline transforms survey data from:
- **Input**: 1 row per respondent with 79+ question columns
- **Output**: Multiple rows per respondent (one per question-answer pair)

**Example:**
```
Before (Wide):
RespondentID | Question1 | Question2 | Question3
1            | Yes       | No        | Maybe

After (Long):
RespondentID | Question   | Answer
1            | Question 1 | Yes
1            | Question 2 | No
1            | Question 3 | Maybe
```

### CROSS APPLY vs UNPIVOT

This project uses **CROSS APPLY with VALUES** instead of traditional UNPIVOT because:

✅ **Data Integrity**: Preserves NULL values (17,028 rows vs 9,664 with UNPIVOT)  
✅ **Complete Analysis**: Maintains non-response patterns for survey completion analysis  
✅ **Explicit Control**: Clear visibility into data transformation logic

See `educational_comparison.sql` for detailed technical comparison.

## 📁 File Structure
```
survey-monkey-pipeline/
├── database_setup.sql          # Database and schema creation
├── bronze_load.sql             # Raw data ingestion procedures
├── silver_load.sql             # Data transformation logic
├── gold_load.sql               # Analytics views and procedures
├── educational_comparison.sql  # UNPIVOT vs CROSS APPLY analysis
└── README.md
```

## 🔧 Configuration

### Critical Settings to Update

1. **File Paths** (`bronze_load.sql`)
```sql
   -- Line 66
   FROM 'YOUR_PATH/edited_survey_monkey_dataset.csv'
   
   -- Line 82
   FROM 'YOUR_PATH/question-subquestion.csv'
```

2. **Database Name** (Optional - default: `survey_monkey`)
```sql
   -- In database_setup.sql
   CREATE DATABASE survey_monkey;
```

## 📈 Key Metrics & Insights

The gold layer provides:
- **Response Rate Analysis**: Count of respondents per question
- **Answer Distribution**: Frequency of each answer choice
- **Demographics Tracking**: Division, position, generation, gender, tenure
- **Completion Patterns**: Identify survey drop-off points

## ⚠️ Important Warnings

- **Data Loss**: `TRUNCATE` operations remove all existing data without backup
- **File Permissions**: SQL Server service account needs read access to CSV files
- **Hard-coded Paths**: Update file paths before running bronze layer procedures
- **NULL Handling**: Uses CROSS APPLY specifically to preserve NULL values for analysis

## 🎓 Learning Resources

This project includes educational materials on:
- SQL Server medallion architecture patterns
- Stored procedure development with error handling
- CROSS APPLY vs UNPIVOT comparison (`educational_comparison.sql`)
- Performance optimization with BULK INSERT and TABLOCK

## 🤝 Contributing

Contributions are welcome! Areas for enhancement:
- Dynamic file path configuration
- Data validation checks
- Incremental load capabilities
- Additional gold layer analytics
- Power BI/Tableau integration examples

## 📝 License

This project is open source and available under the MIT License.

## 👤 Author

**Your Name**
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/muhammad-abdullah-27aa02257)

## 🙏 Acknowledgments

- Survey Monkey for data structure inspiration
- SQL Server community for best practices
- Medallion architecture pattern from Databricks

---

⭐ **Star this repository if you found it helpful!**

For questions or issues, please open a GitHub issue or reach out directly.



## 📂 Repository Structure
```
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
```
---
