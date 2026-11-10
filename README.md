# Supply Chain & Inventory Optimization Analytics

**An end-to-end business intelligence project using SQL, Microsoft Excel, and Power BI**

This project examines how a multi-warehouse business can improve inventory availability, monitor supplier reliability, understand sales performance, and control the value and condition of stock. It brings operational data into a structured analytical workflow and turns it into decision-support views for supply chain stakeholders.

---

## 1. Business Problem

Supply chain teams must balance two competing risks:

- **Too little inventory** can lead to stockouts, missed sales, and delayed customer fulfillment.
- **Too much inventory** ties up working capital, increases holding costs, and can create excess or damaged stock.

At the same time, purchasing and logistics teams need visibility into supplier delivery delays, purchase-order status, shipment outcomes, and warehouse-level performance.

When these signals are reviewed separately, it is difficult to identify which products need replenishment, where inventory value is concentrated, and which suppliers or warehouses need attention.

### Business Objective

Build an integrated analytical view that helps decision-makers:

1. Monitor sales volume and revenue by product, category, and time.
2. Identify stockout exposure and products below reorder thresholds.
3. Compare inventory levels and inventory value across warehouses.
4. Evaluate supplier delivery timeliness and purchase-order status.
5. Review shipment outcomes and damaged inventory.
6. Prioritize replenishment and operational follow-up using measurable indicators.

---

## 2. Tools & Technologies

| Tool | How it is used in this project |
|---|---|
| **Microsoft SQL Server / SQL** | Data exploration, record and null checks, duplicate checks, joins, aggregations, CTEs, sales analysis, stockout analysis, supplier performance, and warehouse inventory valuation. |
| **Microsoft Excel** | Source-data review, spreadsheet-based exploration, and supporting analysis. |
| **Microsoft Power BI** | Interactive reporting and visual analysis of supply chain and inventory KPIs. |
| **AI-assisted analytics** | Used as a productivity aid for understanding SQL concepts, troubleshooting query logic, organizing analysis, and documenting business insights. AI-assisted outputs should be checked against the source data and SQL results. |

**Note:** Python was not used in this project. The workflow is intentionally based on SQL, Excel, and Power BI.

---

## 3. Analytical Workflow

1. **Data familiarization** — review the available product, sales, warehouse, supplier, inventory, purchase-order, shipment, and product-summary data.
2. **Data-quality checks in SQL** — inspect record counts, required-field nulls, and duplicate business identifiers.
3. **Sales performance analysis** — aggregate revenue and units sold by category, product, warehouse, and month.
4. **Inventory analysis** — calculate stockout rates, closing-stock levels, inventory value, and replenishment signals against reorder levels.
5. **Supplier and purchasing analysis** — review purchase-order statuses, late deliveries, average delay, and on-time delivery rates.
6. **Warehouse and shipment analysis** — compare inventory value and damaged units across warehouses and inspect shipment status.
7. **Dashboarding** — present the operational metrics and trends in Power BI for business review.

---

## 4. Key Findings & Business Insights

The SQL analysis is structured around the following operational questions. The table describes the measures produced by the project and how a supply chain team can use them. Exact numeric values are intentionally not stated here unless they have been verified from the final query outputs.

| Area | Measure / analysis | Business interpretation | Potential action |
|---|---|---|---|
| Sales performance | Total revenue, units sold, and sales records | Shows demand and revenue contribution across the business. | Use category and product performance to guide assortment and demand planning. |
| Category contribution | Revenue and units sold by product category | Identifies categories contributing the most sales value and volume. | Align purchasing priorities with category-level demand. |
| Product performance | Top products by revenue and units sold; average selling price | Distinguishes high-value products from high-volume products. | Prioritize availability of commercially important products. |
| Sales trend | Monthly revenue and units sold | Helps identify changes in demand over time. | Use observed trends as an input to replenishment planning. |
| Stockout exposure | Inventory records with zero closing stock and stockout rate | Highlights products and locations with recorded stockout exposure. | Investigate repeated stockouts and review replenishment settings. |
| Reorder monitoring | Closing stock compared with reorder level | Identifies product-warehouse combinations requiring replenishment attention. | Review reorder quantities and purchase-order timing. |
| Inventory investment | Closing stock multiplied by unit cost | Estimates the value of inventory held by category and warehouse. | Review concentration of working capital and potential excess stock. |
| Supplier reliability | On-time delivery rate, late orders, and average delay days | Compares supplier delivery performance. | Escalate recurring delays and review supplier service levels. |
| Purchase-order pipeline | Order counts by purchase-order status | Shows the distribution of delivered, open, and other order statuses in the source data. | Follow up on open or delayed orders. |
| Inventory condition | Damaged units as a percentage of units received | Provides a view of damage exposure by warehouse. | Investigate handling, storage, and supplier-quality issues. |

### Key Business Questions Answered

- Which product categories and products generate the most revenue?
- How does sales performance change month by month?
- Which products have zero closing stock or fall below their reorder level?
- Which warehouses hold the highest inventory value?
- Which suppliers show the greatest delivery delays, and which have stronger on-time performance?
- What share of inventory received is recorded as damaged?

> **Interpretation note:** The SQL file contains the analysis queries, but the numeric result tables are not stored in the repository as separate exports. The findings above therefore describe the verified analytical measures and their business use, rather than inventing totals or rankings. Numeric highlights can be added once the final SQL result exports or dashboard KPI values are available.

---

## 5. Power BI Dashboard

The Power BI report is included in the repository at `powerbi/supplychainanalytics.pbix`.

### Dashboard Screenshots

The screenshots below are embedded using their original filenames.

#### Dashboard View 1
![Supply Chain Dashboard - Screenshot 1](screenshots/Screenshot%202026-11-10%20144140.png)

#### Dashboard View 2
![Supply Chain Dashboard - Screenshot 2](screenshots/Screenshot%202026-11-10%20144204.png)

#### Dashboard View 3
![Supply Chain Dashboard - Screenshot 3](screenshots/Screenshot%202026-11-10%20144231.png)

---

## 6. SQL Concepts Demonstrated

- Database creation and table exploration
- Record-count and null-value checks
- Duplicate identifier checks using `GROUP BY` and `HAVING`
- Multi-table joins across products, sales, inventory, suppliers, warehouses, purchase orders, and shipments
- Aggregations using `SUM`, `COUNT`, and `AVG`
- Conditional metrics using `CASE`
- Date-based analysis using `YEAR`, `MONTH`, and `DATENAME`
- Common Table Expressions (CTEs)
- Division-by-zero protection using `NULLIF`
- Ranking and prioritization using `TOP` and `ORDER BY`

---

## 7. Repository Structure

```text
supply-chain-inventory-analytics/
│
├── README.md
├── data/
│   └── Supply_Chain_Inventory_Optimization_Analytics_Dataset.xlsx
├── sql/
│   └── supply chain.sql
├── powerbi/
│   └── supplychainanalytics.pbix
├── screenshots/
│   ├── Screenshot 2026-11-10 144140.png
│   ├── Screenshot 2026-11-10 144204.png
│   └── Screenshot 2026-11-10 144231.png
└── documentation/
```

---

## 8. Skills Demonstrated

**Technical:** SQL querying, data-quality checks, joins, aggregations, CTEs, Excel analysis, Power BI reporting, KPI development, and data visualization.

**Business:** Inventory monitoring, stockout analysis, reorder-level monitoring, supplier performance, warehouse analysis, sales analysis, and operational decision support.

**AI-assisted productivity:** Using AI tools to support SQL learning and troubleshooting, structure analytical explanations, and draft documentation, with conclusions checked against project data.

---

## 9. Project Limitations & Next Improvements

- Export verified SQL result tables so that numeric findings can be cited directly in this README.
- Add a data dictionary with definitions and units for the source columns.
- Validate every SQL statement against the final database schema and document any query corrections.
- Add dashboard KPI definitions and refresh instructions.
- Extend the analysis with demand forecasting or safety-stock calculations if suitable historical demand and lead-time data are available.

---

## Author

**Vansh**

[GitHub Profile](https://github.com/vanshchhikara686-dot)
