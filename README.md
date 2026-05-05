\# Fintech Credit Card Analytics — dbt + Snowflake



\## Overview



A production-grade analytics engineering project built with dbt and Snowflake,

modelling a synthetic fintech credit card dataset. The project demonstrates

end-to-end data platform design including dimensional modelling, incremental

loading, SCD Type 2 history tracking, a three-tier data quality framework,

a MetricFlow semantic layer, and CI/CD with GitHub Actions.



\## Business Context



The dataset represents a fictional credit card business with 5,000 customers,

3,984 applications, 72,102 transactions, and 3,190 credit limit change events.

The analytical platform answers questions like:



\- What is the approval rate by acquisition channel and employment status?

\- Which customers activated their card within 30 days?

\- What is monthly spend per customer by merchant category?

\- How has a customer's credit limit changed over time?

\- Which cohorts retain best after 3 and 6 months?



\## Architecture

Raw CSV data

down

dbt seed loads into Snowflake RAW schema

down

Staging models clean and standardise

down

Mart models apply business logic

down

Snapshot tracks SCD Type 2 credit limit history

down

MetricFlow defines business metrics as code

down

GitHub Actions runs CI on every pull request



\## Project Structure

models/

staging/        -- one model per source table, views

marts/          -- dim and fct tables, tables + incremental

metrics/        -- MetricFlow semantic models and metrics

snapshots/        -- SCD Type 2 credit limit history

macros/           -- four custom generic test macros

tests/            -- singular business logic tests

seeds/            -- synthetic source data CSVs



\## Data Quality Framework



Three tiers of testing across 59 automated tests:



\- Tier 1 -- Generic tests: not\_null, unique, accepted\_values, relationships

\- Tier 2 -- Custom macros: assert\_column\_is\_positive, assert\_column\_within\_range,

&#x20; assert\_date\_not\_future, assert\_column\_a\_after\_column\_b

\- Tier 3 -- Singular tests: assert\_transaction\_after\_card\_issue



\## Key Technical Decisions



\- fct\_transactions uses incremental materialisation with a 3-day lookback

&#x20; window to handle late-arriving data

\- snap\_credit\_limits uses dbt snapshot with timestamp strategy for SCD Type 2

\- Custom generate\_schema\_name macro overrides dbt default schema behaviour

\- MetricFlow semantic layer defines total\_revenue, transaction\_count, and

&#x20; monthly\_active\_customers as reusable metrics



\## Tech Stack



\- Snowflake -- cloud data warehouse

\- dbt Core 1.11 -- transformation and testing

\- dbt\_utils -- date\_spine for dim\_date

\- dbt\_expectations -- advanced data quality tests

\- GitHub Actions -- CI/CD pipeline

\- Python -- synthetic data generation



\## How to Run



1\. Clone the repo

2\. Install dbt: pip install dbt-snowflake

3\. Configure profiles.yml with your Snowflake credentials

4\. Run: dbt deps

5\. Run: dbt seed

6\. Run: dbt build



\## Portfolio



Notion case study: \[link]



