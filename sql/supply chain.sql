create database supplychainanalytics
use supplychainanalytics
select * from [products]
select 'products' ,count(*) from products
select 'sales' , count(*) from sales
select 'warehouses', count(*) from warehouses
select 'suppliers' , count(*) from suppliers
select 'inventory' , count(*) from inventory
select 'purchase orders',count(*) from [purchase orders]
select 'shipment',count(*) from [dbo].[shipment]
select 'product summary', count(*) from [product summary]
select * from [dbo].[shipment]


select 'product' as tablename,
sum(case when product_id is null then 1 else 0 end) as missing_product_id,
sum(case when product_name is null then 1 else 0 end) as missing_product_name 
from products
union all
select'suppliers' as tablename,
sum(case when supplier_id is null then 1 else 0 end ),
sum(case when supplier_name is null then 1 else 0 end)
from suppliers
union all 
select 'warehouses' as tablename ,
sum(case when warehouse_id is null then 1 else 0 end),
sum(case when warehouse_name is null then 1 else 0 end)
from warehouses
union all
select 'inventory' as tablename ,
sum(case when product_id is null then 1 else 0 end ),
sum(case when warehouse_id is null then 1 else 0 end)
from inventory
union all
select 'purchase order ' as tablename,
sum(case when po_id is null then 1 else 0 end),
sum(case when supplier_id is null then 1 else 0 end)
from [purchase orders]
union all 
SELECT
    'Sales',
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END)
FROM dbo.Sales

UNION ALL

SELECT
    'Shipment',
    SUM(CASE WHEN Shipment_ID IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END)
FROM dbo.Shipment;


USE SupplyChainAnalytics;
GO

-- 1. Duplicate Product IDs
SELECT Product_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;

-- 2. Duplicate Supplier IDs
SELECT Supplier_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Suppliers
GROUP BY Supplier_ID
HAVING COUNT(*) > 1;

-- 3. Duplicate Warehouse IDs
SELECT Warehouse_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Warehouses
GROUP BY Warehouse_ID
HAVING COUNT(*) > 1;

-- 4. Duplicate Purchase Order IDs
SELECT PO_ID, COUNT(*) AS Duplicate_Count
FROM dbo.[purchase orders]
GROUP BY PO_ID
HAVING COUNT(*) > 1;

-- 5. Duplicate Shipment IDs
SELECT Shipment_ID, COUNT(*) AS Duplicate_Count
FROM dbo.Shipment
GROUP BY Shipment_ID
HAVING COUNT(*) > 1;
use supplychainanalytics
select 
count(*) as total_sales_records,
sum(quantity_sold) as total_units_sold,
sum(revenue_inr)as total_revenue_inr
from sales


select 
p.category,
sum(s.Revenue_INR)as total_revenue_inr,
sum(s.Quantity_Sold) as total_quantity_sold,
count(*)as total_sales_records
from dbo.sales as s
inner join dbo.products as p
on s.Product_ID = p.Product_ID
group by p.Category
order by total_revenue_inr desc


select 
top 10
p.product_id,
p.product_name,
p.category ,
sum(s.quantity_sold)as total_units_sold,
sum(s.revenue_inr) as total_revenue_inr
from dbo.sales as s
inner join dbo.products as p
on s.product_id = p.product_id
group by 
p.product_id,
p.product_name,
p.category
order by total_revenue_inr

select 
top 10
p.product_id,
p.product_name,
p.category,
sum(s.quantity_sold) as total_units_sold,
sum(s.revenue_inr) as total_revenue_inr,
cast(
sum(s.revenue_inr)/ nullif (sum(s.quantity_sold),0) as decimal (12,2)) as average_selling_price_inr
from dbo.sales as s
inner join products as p
on s.product_id = p.product_id 
group by 
p.product_id,
p.product_name,
p.category
having sum(s.quantity_sold)>0
order by average_selling_price_inr desc

SELECT TOP 10
    Product_ID,
    Product_Name,
    Category,
    Unit_Cost_INR,
    Selling_Price_INR,
    Reorder_Level
FROM dbo.Products
WHERE Product_ID IN (60, 34, 79, 168, 61, 128, 124, 99, 181, 51);
select * from products
SELECT TOP 10
    s.Product_ID,
    p.Product_Name,
    s.Quantity_Sold,
    p.Selling_Price_INR,
    s.Revenue_INR,
    CAST(
        s.Quantity_Sold * p.Selling_Price_INR
        AS DECIMAL(18, 2)
    ) AS Expected_Revenue_INR
FROM dbo.Sales AS s
INNER JOIN dbo.Products AS p
    ON s.Product_ID = p.Product_ID
ORDER BY s.Revenue_INR DESC;
SELECT
    MIN(Selling_Price_INR) AS Minimum_Selling_Price,
    AVG(Selling_Price_INR) AS Average_Selling_Price,
    MAX(Selling_Price_INR) AS Maximum_Selling_Price
FROM dbo.Products;


select
year(order_date) as sales_year,
month(order_date) as sales_month,
datename(month,order_date)as month_name,
count(*) as total_sales_records,
sum(quantity_sold) as total_units_sold,
cast(
sum(revenue_inr) as decimal (18,2)
) as total_revenue_inr
from sales
group by 
year(order_date),
month(order_date),
datename(month,order_date)
order by 
sales_year,
sales_month

select 
s.warehouse_id,
w.warehouse_name,
count(*) as total_sales_records,
sum(s.quantity_sold) as total_units_sold,
cast(
sum(s.revenue_inr) as decimal (18,2)) as total_revenue_inr
from dbo.sales as s
inner join dbo.warehouses as w
on s.Warehouse_ID = w.Warehouse_ID
group by 
s.Warehouse_ID,
w.Warehouse_Name
order by 
total_revenue_inr


select 
top 10
po.supplier_id,
s.supplier_name,
count(*) as delivered_orders,
sum(
case when po.delivery_days_delay>0
then 1  else 0 
end
) as late_orders,
cast (
avg(case when po.delivery_days_delay>0
then cast (po.delivery_days_delay as decimal (10,2))
end
) as decimal (10,2)
)as avg_delays_days
from dbo.[purchase orders] as po 
inner join suppliers as s
on po.Supplier_ID = s.Supplier_ID
where po.PO_Status = 'delivered'
group by 
po.Supplier_ID,
s.Supplier_Name
order by 
avg_delays_days desc
use supplychainanalytics
select * from [purchase orders]


select 
po.supplier_id,
s.supplier_name,
count(*) as delivered_orders,
sum(
case when po.delivery_days_delay <=0 then 1
else 0
end 
) as on_time_orders,
cast(
100 * sum(case when po.delivery_days_delay<=0 then 1 
else 0 
end 
) / nullif(count(*),0)
as decimal (5,2)
) as on_time_delivery_rate_pct
from [purchase orders] as po
inner join suppliers as s
on po.Supplier_ID = s.Supplier_ID
where po.PO_Status = 'delivered'
group by 
po.Supplier_ID,
s.supplier_name
order by 
on_time_delivery_rate_pct desc,
delivered_orders desc


select 
p.product_id,
p.product_name,
p.category,
count(*) as inventory_records,
sum(
case
when i.closing_stock = 0 then 1 
else 0
end 
) as stockout_records,
cast(
100 * sum(case when i.closing_stock=0 then 1 else 0
end) / nullif(count(*),0) as decimal (5,2)
) as stockout_rate_pct
from inventory as i 
inner join products as p
on i.Product_ID = p.Product_ID
group by 
p.Product_ID,
p.Product_Name,
p.Category
order by 
   Stockout_Rate_Pct DESC,
    Stockout_Records DESC;


    select 
    w.warehouse_id,
    w.warehouse_name,
    count(*) as inventory_records,
    sum(i.closing_stock) as total_closing_stock_units,
    cast(
    sum(i.closing_stock * p.unit_cost_inr)
    as decimal(18,2))
    as total_inventory_value_inr
    from inventory as i 
    inner join products as p 
    on i.Product_ID = p.Product_ID
    inner join warehouses as w
    on i.Warehouse_ID = w.Warehouse_ID
group by 
w.Warehouse_ID,
w.Warehouse_Name 
order by 
total_inventory_value_inr desc
select * from [purchase orders]

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    w.Warehouse_Name,
    p.Reorder_Level,
    SUM(i.Closing_Stock) AS Warehouse_Closing_Stock,
    CASE
        WHEN SUM(i.Closing_Stock) = 0 THEN 'Out of Stock'
        WHEN SUM(i.Closing_Stock) < p.Reorder_Level THEN 'Reorder Required'
        ELSE 'Stock Sufficient'
    END AS Reorder_Status
FROM dbo.Inventory AS i
INNER JOIN dbo.Products AS p
    ON i.Product_ID = p.Product_ID
INNER JOIN dbo.Warehouses AS w
    ON i.Warehouse_ID = w.Warehouse_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    w.Warehouse_Name,
    p.Reorder_Level
HAVING
    SUM(i.Closing_Stock) < p.Reorder_Level
ORDER BY
    Warehouse_Closing_Stock ASC;


    select 
    w.warehouse_id,
    w.warehouse_name,
    count(*) as total_inventory_records,
    sum(
    case
    when i.closing_stock = 0 then 1 
    else 0
    end
    ) as stockout_records,
    cast(
    100*sum(case
    when i.closing_stock =0 then 1
    else 0 
    end)/ nullif (count(*),0)
    as decimal(5,2)) as stock_out_rate_pct
    from inventory as i 
    inner join warehouses as w 
    on i.Warehouse_ID = w.warehouse_id
    group by 
    w.Warehouse_ID,
    w.Warehouse_Name
    order by 
    stockout_records desc,
    stock_out_rate_pct desc


    with productrevenue as (
    select 
    product_id,
    sum(revenue_inr) as total_revenue_inr
    from sales
    group by 
    Product_ID),
    productstocks as (
    select product_id,
    sum(closing_stock)as total_closing_stock
    from inventory
    group by product_id)
    select 
    p.product_id,
    p.product_name,
    p.category,
    cast(
    r.total_revenue_inr as decimal (18,2))
    as total_revenue_inr,
    st.total_closing_stock,
    p.reorder_level
    from products as p
    inner join productrevenue as r
    on p.Product_ID = r.Product_ID
    inner join productstocks as st
    on p.Product_ID = st.Product_ID
    
    order by r.total_revenue_inr desc

    with productsales as (
    select 
    sum(quantity_sold)as total_unit_sold
    from sales
    group by product_id),
    productinventory as 
    ( select 
    product_id,
    avg(closing_stock*1) as average_recorded_stock
    from inventory
    group by product_id
    )
    select
    p.product_id,
    p.product_name,
    p.category,
ps.total_units_sold,
cast(
pin.average_recorded_stock as decimal(18,2)
) as average_recorded_stock,
cast(ps.total_units_sold/
nullif(pin.average_recorded_stock,0)
as decimal(18,2)) as inventory_turnover_proxy
from products as p
inner join productsales as ps
on p.Product_ID = ps.product_id
inner join productinventory as pin
on p.Product_ID = pin.Product_ID
order by inventory_turnover_proxy desc




WITH ProductSales AS (
    SELECT
        Product_ID,
        SUM(Quantity_Sold) AS Total_Units_Sold
    FROM dbo.Sales
    GROUP BY Product_ID
),
ProductInventory AS (
    SELECT
        Product_ID,
        AVG(Closing_Stock * 1.0) AS Average_Recorded_Stock
    FROM dbo.Inventory
    GROUP BY Product_ID
)
SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    ps.Total_Units_Sold,
    CAST(
        pi.Average_Recorded_Stock AS DECIMAL(18, 2)
    ) AS Average_Recorded_Stock,
    CAST(
        ps.Total_Units_Sold /
        NULLIF(pi.Average_Recorded_Stock, 0)
        AS DECIMAL(18, 2)
    ) AS Inventory_Turnover_Proxy
FROM dbo.Products AS p
INNER JOIN ProductSales AS ps
    ON p.Product_ID = ps.Product_ID
INNER JOIN ProductInventory AS pi
    ON p.Product_ID = pi.Product_ID
ORDER BY
    Inventory_Turnover_Proxy DESC;


    select 
    p.category,
    sum(i.closing_stock) as total_units_in_stock,
    cast(
    sum(i.closing_stock*p.unit_cost_inr) as decimal(18,2)
    ) as total_inventory_value
    from inventory as i
    inner join products as p
    on i.Product_ID = p.Product_ID
    group by 
    p.category
    order by 
    total_inventory_value desc


    select
    w.warehouse_id,
    w.warehouse_name,
    count(*)as inventory_records,
    sum(i.closing_stock) as total_units_in_stock,
    cast(
    sum(i.closing_stock*p.unit_cost_inr)as decimal(18,2)
    ) as total_inventory_value_inr
    from inventory as i
    inner join products as p
    on i.Product_ID = p.Product_ID
    inner join warehouses as w
    on i.Warehouse_ID = w.Warehouse_ID
    group by 
    w.Warehouse_ID,
    w.Warehouse_Name
    order by 
    total_inventory_value_inr desc


    select
   s. supplier_id,
   s. supplier_name,
    count(*)as total_purchase_orders,
    sum(
    case when po.po_status = 'delivere' then 1
    else 0 
    end) as delivered_orders,
    sum(case
    when po.po_status = 'open'then 1
    else 0 end)as open_orders
    from [purchase orders] as po
    inner join suppliers as s
    on po.Supplier_ID = s.Supplier_ID
    group by 
    s.Supplier_ID,
    s.Supplier_Name
    order by
    total_purchase_orders desc

    use supplychainanalytics

    select
    po_status,
    count(*) as total_orders,
    cast(100*count(*)/nullif ((select count(*) from [purchase orders]),0)
    as decimal(5,2))as percentage_of_orders
    from [purchase orders]
    group by 
    PO_Status
    order by
    total_orders desc


    SELECT
    PO_Status,
    COUNT(*) AS Total_Orders,
    CAST(
        100.0 * COUNT(*) /
        NULLIF((SELECT COUNT(*) FROM dbo.[purchase orders]), 0)
        AS DECIMAL(5, 2)
    ) AS Percentage_of_Orders
FROM dbo.[purchase orders]
GROUP BY PO_Status
ORDER BY Total_Orders DESC;

select * from sales
select 
s.supplier_id,
s.supplier_name,
count(*) as delivered_orders,
sum(case 
when po.delivery_days_delay >0 then 1 else 0
end) as late_orders,
cast(
avg(case 
when po.delivery_days_delay>0 
then cast (po.delivery_days_delay as decimal(10,2))
end) as decimal(10,2)) as average_late_delivery_days
from [dbo].[purchase orders] as po 
inner join suppliers as s
on po.supplier_id = s.supplier_id
where 
po.po_status = 'delivered'
group by 
s.Supplier_ID,
s.Supplier_Name
order by
average_late_delivery_days desc



select 
delivery_status,
count(*)as total_shipments,
cast(
100*count(*)/nullif ((select count(*) from shipment),0)
as decimal(10,2) ) as average_transit_days
from shipment
group by 
Delivery_Status
order by 
total_shipments desc
select * from sales
select
year(Order_Date) as sales_year,
month(Order_Date) as sales_month,
datename(month,Order_Date) as month_name,
sum(quantity_sold) as total_units_sold,
cast(sum(revenue_inr) as decimal(18,2) ) as total_revenue_inr
from sales
group by 
year(order_date),
month(order_date),
datename(month ,order_date)
order by 
total_revenue_inr desc



SELECT TOP 10
    p.Product_ID,
    p.Product_Name,
    p.Category,
    SUM(s.Quantity_Sold) AS Total_Units_Sold,
    COUNT(*) AS Total_Sales_Records,
    CAST(SUM(s.Revenue_INR) AS DECIMAL(18, 2)) AS Total_Revenue_INR
FROM dbo.Sales AS s
INNER JOIN dbo.Products AS p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category
ORDER BY
    Total_Units_Sold ASC;
    select * from inventory

    select
    i.product_id,
    p.product_name,
    p.category,
    i.warehouse_id,
    w.warehouse_name,
    i.closing_stock,
    i.reorder_status,
    i.reorder_status - i.closing_stock as units_below_reorder_level
    from inventory as i
    inner join on [dbo].[products] as p
    on i.product_id = p.product_id
    inner join on warehouses as w
    on i.warehouse_id = w.warehouse_id
    where i.closing_stock<i.reorder_status
    order by units_below_reorder_level

    SELECT
    i.Product_ID,
    p.Product_Name,
    p.Category,
    i.Warehouse_ID,
    w.Warehouse_Name,
    i.Closing_Stock,
    i.reorder_status,
    i.reorder_status - i.Closing_Stock AS Units_Below_Reorder_Level
FROM dbo.Inventory AS i
INNER JOIN dbo.Products AS p
    ON i.Product_ID = p.Product_ID
INNER JOIN dbo.Warehouses AS w
    ON i.Warehouse_ID = w.Warehouse_ID
WHERE i.Closing_Stock < i.reorder_status
ORDER BY
    Units_Below_Reorder_Level DESC;

    SELECT TOP 5 *
FROM dbo.inventory;

SELECT
    i.Date,
    i.Product_ID,
    p.Product_Name,
    p.Category,
    i.Warehouse_ID,
    w.Warehouse_Name,
    i.Closing_Stock,
    i.reorder_status
FROM dbo.inventory AS i
INNER JOIN dbo.products AS p
    ON i.Product_ID = p.Product_ID
INNER JOIN dbo.warehouses AS w
    ON i.Warehouse_ID = w.Warehouse_ID
WHERE UPPER(i.reorder_status) <> 'SUFFICIENT'
ORDER BY i.Closing_Stock ASC;

SELECT
    w.Warehouse_ID,
    w.Warehouse_Name,
    SUM(i.Damaged_Units) AS Total_Damaged_Units,
    COUNT(*) AS Inventory_Records,
    CAST(
        100.0 * SUM(i.Damaged_Units) /
        NULLIF(SUM(i.Units_Received), 0)
        AS DECIMAL(10, 2)
    ) AS Damaged_Units_Percentage
FROM dbo.Inventory AS i
INNER JOIN dbo.Warehouses AS w
    ON i.Warehouse_ID = w.Warehouse_ID
GROUP BY
    w.Warehouse_ID,
    w.Warehouse_Name
ORDER BY
    Total_Damaged_Units DESC;