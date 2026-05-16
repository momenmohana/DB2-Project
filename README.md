# DB2-Project

A data warehouse project built on the **Sakila** movie rental OLTP database, implementing dimensional modeling with a full Python-based ETL pipeline.

> **An-Najah National University** — Faculty of Information Technology and Artificial Intelligence  
> Department of Computer Science  
> Supervisor: Dr. Mo'men Abughazala

**Team:**
- Mo'men Mhana (12323848)
- Samer Awaissah (12323992)

---

## 📌 Overview

This project transforms the Sakila OLTP database into an analytical data warehouse designed to support business intelligence and reporting. The warehouse uses a **Star Schema** (with a hybrid bridge table approach) and was built using Python, Pandas, and SQLAlchemy.

---

## 🗄️ Schema Design

The warehouse uses a **Hybrid Star Schema** with the following tables:

### Fact Tables
| Table | Grain | Key Measures |
|---|---|---|
| `fact_rental_film` | One record per rental transaction | `rental_duration`, `days_late`, `rental_count` |
| `fact_payment` | One record per payment transaction | `amount`, `payment_count` |
| `fact_store_performance` | One record per store per date | `total_rentals`, `total_revenue`, `total_late_returns` |

### Dimension Tables
| Table | Key Attributes |
|---|---|
| `dim_film` | title, rating, rental_rate, rental_duration, release_year |
| `dim_category` | category_name |
| `dim_customer` | full_name, email, city, country |
| `dim_store` | manager_name, city, country |
| `dim_staff` | full_name, store_id |
| `dim_location` | city, country, district |
| `dim_date` | full_date, day_name, month, quarter, year |

### Bridge Table
- `bridge_film_category` — handles the many-to-many relationship between films and categories

---

## ⚙️ ETL Pipeline

The ETL process is implemented in `db.ipynb` using:
- **Python** + **Pandas** for data transformation
- **SQLAlchemy** for database connections

### Pipeline Steps

```
Extract (Sakila OLTP)
    ↓
Transform (clean, join, derive attributes)
    ↓
Load (movie_rental Data Warehouse)
```

### Loading Order
1. `dim_film`
2. `dim_category`
3. `bridge_film_category`
4. `dim_store`
5. `dim_customer`
6. `dim_staff`
7. `dim_location`
8. `dim_date`
9. `fact_rental_film`
10. `fact_payment`
11. `fact_store_performance`

---

## 🧹 Data Quality

The following data quality rules were applied during ETL:

- ✅ Null checks on all dimension and fact tables (`isnull().sum()`)
- ✅ Null removal from date dimension (`dropna()`)
- ✅ Duplicate removal from date dimension (`drop_duplicates()`)
- ✅ Negative `days_late` values replaced with 0 (`clip(lower=0)`)
- ✅ Remaining nulls in `days_late` filled with 0 (`fillna(0)`)
- ✅ Surrogate key columns cast to integer (`astype(int)`)

---

## 📊 Business Questions Supported

| Question | Purpose |
|---|---|
| Which films are rented most frequently? | Inventory & marketing decisions |
| Which films generate the highest revenue? | Profitability analysis |
| Which stores generate the most rentals/revenue? | Store performance comparison |
| Which customers generate the highest revenue? | Customer relationship management |
| How does rental activity change over time? | Trend & seasonal analysis |
| Which staff process the most payments? | Employee performance evaluation |
| Which films are returned late most often? | Rental policy improvement |

---

## 🚀 Getting Started

### Prerequisites

```bash
pip install pandas sqlalchemy pymysql matplotlib
```

### Database Setup

1. Install and set up **MySQL**
2. Import the **Sakila** database (source OLTP)
3. Create an empty database named `movie_rental` (destination)

### Configuration

Open `db.ipynb` and update the connection credentials:

```python
username = "root"
password = "your_password"
host = "127.0.0.1"
port = 3306
```

### Run

Execute all cells in `db.ipynb` from top to bottom. The ETL will:
1. Extract all tables from the Sakila database
2. Transform and clean the data
3. Load the dimensional model into `movie_rental`

---

## 📁 Project Structure

```
├── db.ipynb          # ETL pipeline + visualizations
├── DB2.pdf           # Full project report
└── README.md
```

---

## 📈 Visualizations Included

The notebook includes the following analytical charts:

1. **Top 10 Most Rented Films**
2. **Revenue by Store**
3. **Monthly Rental Trend**
4. **Top Customers by Payments**
5. **Late Returns Analysis**
