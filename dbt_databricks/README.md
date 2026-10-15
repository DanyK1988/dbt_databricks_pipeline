# Databricks Pipeline dbt Project

This directory contains the dbt models, seeds, snapshots, analyses, tests, macros, and configuration for the Databricks Medallion data pipeline.

For full project documentation, architecture diagrams, and setup instructions, refer to the [Root README.md](../README.md).

### Quick Commands

Run from this directory:

```bash
# Debug profile and warehouse connection
dbt debug

# Load seeds
dbt seed

# Run all models (or by layer / target)
dbt run
dbt run --select silver
dbt run --target prod

# Run snapshots (SCD Type 2)
dbt snapshot

# Run tests
dbt test

# Generate and view documentation
dbt docs generate && dbt docs serve
```
