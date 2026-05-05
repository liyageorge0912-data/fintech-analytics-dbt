\# fct\_transactions — Data Contract



\## Owner

Liya George | liyageorge0912@gmail.com



\## Grain

One row per transaction. Each transaction\_id is unique and never null.



\## Freshness

Updated on every dbt run. Source data loaded via dbt seed.



\## Guaranteed Columns



| Column | Type | Nullable | Description |

|---|---|---|---|

| transaction\_id | varchar | No | Primary key |

| customer\_id | varchar | No | Foreign key to dim\_customers |

| application\_id | varchar | No | Foreign key to fct\_applications |

| amount | decimal | No | Transaction amount in GBP. Always > 0 |

| currency | varchar | No | Always GBP |

| merchant\_category | varchar | No | One of 8 categories |

| status | varchar | No | One of: completed, pending, failed, refunded |

| transaction\_date | date | No | Date of transaction. Never in the future |

| completed\_amount | decimal | No | Amount if completed, else 0 |

| refunded\_amount | decimal | No | Amount if refunded, else 0 |



\## Quality Guarantees

\- transaction\_id is unique and never null

\- amount is always greater than 0 and less than 10,000

\- status is always one of the four accepted values

\- transaction\_date is never in the future

\- Every customer\_id exists in dim\_customers

\- Every transaction\_date is after the customer's card\_issued\_at



\## Tests

\- 59 automated tests run on every dbt build

\- Custom macros: assert\_column\_is\_positive, assert\_column\_within\_range,

&#x20; assert\_date\_not\_future

\- Singular test: assert\_transaction\_after\_card\_issue



\## Breaking Change Policy

Any changes to column names, types, or removal of columns will be

communicated to all consumers at least 5 business days in advance.



\## Non-Guaranteed Columns

\- created\_at (internal metadata)

\- updated\_at (internal metadata)

