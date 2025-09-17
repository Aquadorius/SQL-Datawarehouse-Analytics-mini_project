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
