# Architecture

## High-Level Diagram (Text)

[Airbyte] → [dbt] → [BigQuery/GCS] → [Looker Studio]

## Components
- Airbyte: Data ingestion
- dbt: Data transformation
- BigQuery/GCS: Storage
- Looker Studio: Analytics/dashboard
- Terraform: Infrastructure management
- GitHub Actions: CI/CD
