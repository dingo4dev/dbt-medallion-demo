# dbt Medallion Architecture Demo

A demo dbt project showcasing the **Medallion Architecture** (Bronze → Silver → Gold) using **dbt-duckdb**.

## 🏗️ Architecture

### Medallion Layers

```
┌─────────────┐
│   Raw Data  │ CSV Seeds
│  (Sources)  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   BRONZE    │ Raw ingestion with metadata
│   (Views)   │ - Minimal transformation
└──────┬──────┘ - Add _loaded_at, _batch_id
       │
       ▼
┌─────────────┐
│   SILVER    │ Cleaned & validated
│   (Views)   │ - Data quality rules
└──────┬──────┘ - Standardized formats
       │        - Business logic
       ▼
┌─────────────┐
│    GOLD     │ Business-ready aggregates
│  (Tables)   │ - Analytics metrics
└─────────────┘ - Customer segments
                - Sales KPIs
```

## 📊 Data Model

### Seeds (Raw Data)
- `raw_customers.csv` - Customer master data
- `raw_orders.csv` - Order transactions
- `raw_products.csv` - Product catalog

### Bronze Layer
- `bronze_customers` - Raw customer data + metadata
- `bronze_orders` - Raw order data + metadata
- `bronze_products` - Raw product data + metadata

### Silver Layer
- `silver_customers` - Validated & normalized customers
- `silver_orders` - Validated orders with business flags
- `silver_products` - Validated products with price tiers

### Gold Layer
- `gold_customer_summary` - Customer analytics & segmentation
- `gold_daily_sales` - Daily sales metrics & KPIs
- `gold_country_summary` - Country-level revenue analysis

## 🚀 Quick Start

### Prerequisites

**Install uv (fast Python package manager):**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Setup

```bash
# Create virtual environment
uv venv

# Activate it
source .venv/bin/activate

# Install dependencies (much faster than pip!)
uv pip install -r requirements.txt
# or
uv pip install dbt-duckdb pre-commit
```
```bash
# Install dependencies
dbt deps

# Load seed data
dbt seed

# Build all models
dbt build

# Or run step by step:
dbt run --models tag:bronze
dbt run --models tag:silver
dbt run --models tag:gold
```

### Run Tests
```bash
dbt test
```

### Generate Documentation
```bash
dbt docs generate
dbt docs serve
```

## 📁 Project Structure

```
dbt-medallion-demo/
├── dbt_project.yml          # Project configuration
├── profiles.yml             # Connection profiles
├── models/
│   ├── bronze/              # Raw data layer
│   │   ├── bronze_customers.sql
│   │   ├── bronze_orders.sql
│   │   └── bronze_products.sql
│   ├── silver/              # Cleaned data layer
│   │   ├── silver_customers.sql
│   │   ├── silver_orders.sql
│   │   └── silver_products.sql
│   └── gold/                # Business layer
│       ├── gold_customer_summary.sql
│       ├── gold_daily_sales.sql
│       └── gold_country_summary.sql
├── seeds/
│   ├── raw_customers.csv
│   ├── raw_orders.csv
│   └── raw_products.csv
├── tests/                   # Data tests
└── macros/                  # Custom macros
```

## 🛠️ Technology Stack

- **dbt-core**: 1.11.x
- **dbt-duckdb**: 1.10.x
- **DuckDB**: In-process SQL OLAP database
- **Python**: 3.12+
- **uv**: Fast Python package manager
- **pre-commit**: Git hooks for code quality

## 📝 Best Practices Implemented

✅ **Layered Architecture** - Clear separation of concerns (Bronze/Silver/Gold)
✅ **Data Quality** - Validation rules in Silver layer
✅ **Incremental Logic** - Ready for production incremental models
✅ **Metadata Tracking** - `_loaded_at` and `_batch_id` in Bronze
✅ **Business Logic** - Customer segmentation and KPIs in Gold
✅ **Testing** - Schema tests and custom data quality tests
✅ **Documentation** - Inline docs and descriptions
✅ **Version Control** - Pre-commit hooks for consistency
✅ **Modern Tooling** - Uses `uv` for fast dependency management

## 🔍 Example Queries

### Top customers by revenue:
```sql
SELECT
    customer_name,
    total_revenue,
    customer_segment
FROM gold_customer_summary
ORDER BY total_revenue DESC
LIMIT 10;
```

### Daily sales trend:
```sql
SELECT
    order_date,
    daily_revenue,
    completed_orders
FROM gold_daily_sales
ORDER BY order_date;
```

### Revenue by country:
```sql
SELECT
    country,
    total_revenue,
    revenue_per_customer
FROM gold_country_summary
ORDER BY total_revenue DESC;
```

## 🧪 Development

### Run specific layers:
```bash
dbt run --models tag:bronze
dbt run --models tag:silver
dbt run --models tag:gold
```

### Run specific models:
```bash
dbt run --models gold_customer_summary
```

### Test specific models:
```bash
dbt test --models silver_customers
```

## 📊 View the Demo

### 🎨 Modern UI (43KB - NEW!)
Open `demo/modern-docs.html` in your browser to see the modern, lightweight alternative!

**Features:**
- ✨ Single HTML file (43KB vs 1.7MB default)
- 🎨 Modern, clean interface with Tailwind CSS
- 🌙 Dark mode support
- 📊 Dashboard with real-time stats
- 🔍 Live search across models, sources, and tests
- 📱 Fully responsive design

Check out [dbt-docs-modern](https://github.com/dingo4dev/dbt-docs-modern) for more details!

### Traditional dbt Docs
```bash
dbt docs serve --profiles-dir .
```

Or view the pre-generated version at `target/index.html`.

## 📚 Learn More

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt-duckdb Adapter](https://github.com/duckdb/dbt-duckdb)
- [Medallion Architecture](https://www.databricks.com/glossary/medallion-architecture)
- [DuckDB](https://duckdb.org/)

## 📄 License

MIT License - Feel free to use this as a template!
