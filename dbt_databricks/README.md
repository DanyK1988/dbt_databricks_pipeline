# Databricks Pipeline dbt Project

This directory contains the dbt models, tests, macros, and configuration for the Databricks Medallion data pipeline.

For full project documentation, architecture diagrams, and setup instructions, refer to the [Root README.md](../README.md).

### Quick Commands

Run from this directory:

```bash
# Debug profile and warehouse connection
dbt debug

# Run all models
dbt run

# Run tests
dbt test

# Generate and view documentation
dbt docs generate && dbt docs serve
```
