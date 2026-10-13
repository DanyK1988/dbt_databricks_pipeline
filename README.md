# Databricks dbt Data Pipeline

A modern data transformation pipeline built with **dbt (data build tool)** and **Databricks**, implementing a **Medallion Architecture (Bronze → Silver → Gold)**.

---

## 🏗️ Architecture Overview

The pipeline ingests raw sales and retail data into Databricks Unity Catalog (`dbt_vault`) and processes it through layered transformations:

```mermaid
flowchart LR
    subgraph Sources [Raw Source Tables]
        S1[(fact_sales)]
        S2[(fact_returns)]
        S3[(dim_date)]
        S4[(dim_store)]
        S5[(dim_product)]
        S6[(dim_customer)]
    end

    subgraph Bronze [Bronze Layer (Ingestion & Schema Standardization)]
        B1[bronze_sales]
        B2[bronze_returns]
        B3[bronze_date]
        B4[bronze_store]
        B5[bronze_product]
        B6[bronze_customer]
    end

    subgraph Silver [Silver Layer (Cleansing & Conformance)]
        SV[Silver Models (Planned)]
    end

    subgraph Gold [Gold Layer (Aggregations & Business Marts)]
        GD[Gold Models (Planned)]
    end

    Sources --> Bronze
    Bronze --> Silver
    Silver --> Gold
```

### Medallion Layers
* **Bronze (`dbt_vault.bronze`)**: Raw 1:1 ingestion layer from source catalog/schema (`dbt_vault.source.*`). Default materialization is `view` (with select tables materialized as `table`).
* **Silver (`dbt_vault.silver`)**: Cleaned, filtered, deduplicated, and conformed data (materialized as `table`).
* **Gold (`dbt_vault.gold`)**: High-performance business-level aggregates and dimension/fact models (materialized as `incremental`).

---

## 📁 Repository Structure

```text
dbt_course/
├── src/                               # Source CSV datasets (sales, returns, dimensions)
├── pyproject.toml                     # Python dependencies (managed via uv / pip)
├── .env.example                       # Example environment variables
├── README.md                          # Project documentation
└── dbt_databricks/                    # dbt project root
    ├── dbt_project.yml                # dbt project configuration and layer defaults
    ├── profiles.yml                   # Databricks connection profile
    ├── models/
    │   ├── sources/
    │   │   └── sources.yml            # Source definitions for raw Unity Catalog tables
    │   ├── bronze/                    # Bronze layer models & schema tests
    │   │   ├── bronze_customer.sql
    │   │   ├── bronze_date.sql
    │   │   ├── bronze_product.sql
    │   │   ├── bronze_returns.sql
    │   │   ├── bronze_sales.sql
    │   │   ├── bronze_store.sql
    │   │   └── properties.yml         # Model documentation and column tests
    │   ├── silver/                    # (Planned) Cleansed enterprise models
    │   └── gold/                      # (Planned) Analytical reporting models
    ├── macros/
    │   └── generate_schema.sql        # Custom schema naming macro (avoids default prefixes)
    └── tests/
        ├── generic/
        │   └── generic_non_negative.sql # Custom generic data test
        └── non_negative_test.sql        # Singular data validation test
```

---

## ⚙️ Tech Stack & Requirements

* **Python**: `>=3.13`
* **Package Manager**: [uv](https://github.com/astral-sh/uv) (or `pip` / `venv`)
* **dbt Core**: `1.12.5+`
* **dbt-databricks**: `1.12.6+`
* **Target Warehouse**: Databricks SQL Warehouse (Unity Catalog enabled)

---

## 🚀 Getting Started

### 1. Environment Setup

Clone the repository and install dependencies:

```bash
# Using uv (recommended)
uv sync

# Or using standard venv + pip
python3 -m venv .venv
source .venv/bin/activate
pip install dbt-core dbt-databricks
```

### 2. Configure Environment Variables

The `profiles.yml` reads your Databricks Personal Access Token from the environment:

```bash
export DATABRICKS_TOKEN="your_personal_access_token_here"
```

Or store it in a local `.env` file (ensure `.env` is ignored by git):

```env
DATABRICKS_TOKEN=your_personal_access_token_here
```

### 3. Verify Connection

Navigate into `dbt_databricks/` and test connection:

```bash
cd dbt_databricks
dbt debug
```

---

## 🏃 Running and Testing

### Run Models
```bash
# Run all models
dbt run

# Run only the bronze layer
dbt run --select bronze

# Run a specific model
dbt run --select bronze_sales
```

### Run Tests
```bash
# Run all tests
dbt test

# Run tests on bronze layer only
dbt test --select bronze
```

### Generate and Serve Documentation
```bash
dbt docs generate
dbt docs serve
```

---

## 🧪 Data Testing & Quality

* **Generic Tests**:
  * `not_null` & `unique` on key columns (e.g., `sales_id`, `store_sk`).
  * `accepted_values` on `store_name` (configured with `severity: warn`).
  * `generic_non_negative`: Custom macro test verifying numeric columns (such as `gross_amount` and `net_amount`) are non-negative (`>= 0`).
* **Singular Tests**:
  * Validation queries in `tests/` verifying data anomalies across sales records.

---

## 🔧 Macros & Customizations

* **`generate_schema_name`** ([macros/generate_schema.sql](dbt_databricks/macros/generate_schema.sql)):
  Overrides dbt's default behavior of prefixing custom schemas with the target schema (e.g. producing `default_bronze`). Instead, it outputs clean schema names directly (`bronze`, `silver`, `gold`).
