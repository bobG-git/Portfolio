-- Calculating marketing KPIs from  marketing data across different digital media channels --



-- Step 1: Data preperation and quality verification --


-- Checking data for missing values and 0s --
SELECT *
FROM marketing
WHERE
  id IS NULL OR id = '' OR
  c_date IS NULL OR c_date = '' OR
  campaign_name IS NULL OR campaign_name = '' OR
  category IS NULL OR category = '' OR
  campaign_id IS NULL OR campaign_id = '' OR
  impressions IS NULL OR impressions = 0 OR
  mark_spent IS NULL OR mark_spent = 0 OR
  clicks IS NULL OR clicks = 0 OR
  leads IS NULL OR leads = 0 OR
  orders IS NULL OR orders = 0 OR
  revenue IS NULL OR revenue = 0;
-- The data appears to be in good shape, with no missing values and zeros appropriately accounted for --


-- Next up, identifing duplicate records based on key columns using the ROW_NUMBER() function --
WITH CTE AS (
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY 
id, c_date, campaign_name, category, campaign_id, impressions, mark_spent, clicks, leads,
orders, revenue) as row_num
FROM sales.marketing)

SELECT *
FROM CTE
WHERE row_num >1;
-- Luckily no duplicates were found either --


-- Creating a copy of the 'marketing' table structure for testing purposes -- 
USE sales;

CREATE TABLE marketing2
LIKE marketing;

INSERT INTO marketing2
SELECT *
FROM marketing;



-- Step 2 : KPI calculations --


-- Calculating all the KPIs -- 

SELECT *,
CASE 
    WHEN orders = 0 THEN 0
    ELSE
        (CAST(orders AS DOUBLE) / NULLIF((SELECT SUM(orders) FROM marketing2), 0)) * 100
END AS percent_of_total_orders,
 
    
revenue - mark_spent AS `Profit`,

((revenue - mark_spent) / NULLIF((SELECT SUM(revenue) - SUM(mark_spent) FROM marketing2), 0)) * 100 
AS percent_of_total_profit,

(revenue - mark_spent) / NULLIF((SELECT SUM(revenue) FROM marketing2), 0) * 100 
AS percentage_return_based_on_total_revenue,

CASE 
    WHEN orders = 0 THEN 0 
    ELSE revenue / orders 
  END AS `Average_Order_Value(AOV)`,
  
  ((revenue - mark_spent) / NULLIF(mark_spent, 0)) * 100 AS ROI,
  -- how would you deal with it if mark_spent was 0 and revenue has $1000? (ROI)

  CASE 
    WHEN leads = 0 THEN 0 
    ELSE mark_spent / leads 
  END AS `Customer-Acquisition-Cost/Cost-per-Lead`,
  
  CASE 
  WHEN impressions = 0 THEN 0 
  ELSE (CAST(clicks AS DOUBLE) / impressions) * 100 
END AS `Click-through-rate %`,

  CASE 
    WHEN clicks = 0 THEN 0 
    ELSE mark_spent / clicks 
  END AS `Cost-per-click`,
  
  CASE
	WHEN clicks = 0 THEN 0 
	ELSE clicks/ NULLIF((SELECT SUM(clicks) FROM marketing2), 0) * 100 
 END AS percent_of_total_clicks,
  
  CASE 
    WHEN clicks = 0 THEN 0 
    ELSE revenue / clicks 
  END AS `Revenue-per-click`

 -- Percent of total impressions
  (CAST(impressions AS DOUBLE) / (SELECT SUM(impressions) FROM marketing3)) * 100
  AS percent_of_total_impressions, 
	  

  -- Percent of total leads
  (CAST(leads AS DOUBLE) / (SELECT SUM(leads) FROM marketing3)) * 100
     AS percent_of_total_leads,

  -- Revenue per impression
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (revenue / CAST(impressions AS DOUBLE))
    END 
   AS revenue_per_impression,

    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (revenue / CAST(impressions AS DOUBLE)) * 100
    END 
   AS revenue_per_100impressions,

    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (revenue / CAST(impressions AS DOUBLE)) * 1000
    END 
   AS revenue_per_1000impressions,

  -- Cost per impression
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE mark_spent / CAST(impressions AS DOUBLE)
    END 
  AS cost_per_impression,

    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (mark_spent / CAST(impressions AS DOUBLE)) * 100
    END 
   AS cost_per_100impressions,

    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (mark_spent / CAST(impressions AS DOUBLE)) * 1000
    END 
   AS cost_per_1000impressions,

  -- Profit per impression
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE profit / CAST(impressions AS DOUBLE)
    END 
  AS profit_per_impression,

  CAST(
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (profit / CAST(impressions AS DOUBLE)) * 100
    END 
  AS DOUBLE) AS profit_per_100impressions,

  CAST(
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (profit / CAST(impressions AS DOUBLE)) * 1000
    END 
  AS DOUBLE) AS profit_per_1000impressions,

  -- Impressions per click
    CASE 
      WHEN clicks = 0 THEN 0
      ELSE impressions / CAST(clicks AS DOUBLE)
    END 
  AS impressions_per_click,

    CASE 
      WHEN clicks = 0 THEN 0
      ELSE (impressions / CAST(clicks AS DOUBLE)) * 100
    END 
  AS impressions_per_100clicks,

    CASE 
      WHEN clicks = 0 THEN 0
      ELSE (impressions / CAST(clicks AS DOUBLE)) * 1000
    END 
  AS impressions_per_1000clicks,

  -- Clicks per lead
    CASE 
      WHEN leads = 0 THEN 0
      ELSE clicks / CAST(leads AS DOUBLE)
    END 
  AS clicks_per_leads,

  -- Leads per click
    CASE 
      WHEN clicks = 0 THEN 0
      ELSE leads / CAST(clicks AS DOUBLE)
    END 
   AS leads_per_click,

  -- Orders per lead
    CASE 
      WHEN leads = 0 THEN 0
      ELSE orders / CAST(leads AS DOUBLE)
    END 
   AS orders_per_lead,

  -- Leads per order
    CASE 
      WHEN orders = 0 THEN 0
      ELSE leads / CAST(orders AS DOUBLE)
    END 
   AS lead_per_order,

  -- Cost per order
    CASE 
      WHEN orders = 0 THEN 0
      ELSE mark_spent / CAST(orders AS DOUBLE)
    END 
   AS cost_per_order,

  -- Per-dollar contribution to order

    CASE 
      WHEN mark_spent = 0 THEN 0
      ELSE orders / CAST(mark_spent AS DOUBLE)
    END 
   AS per_dollar_contribution_to_order,
   
 -- Percent of marketing expense  
(CAST(mark_spent as double)/(SELECT SUM(mark_spent) FROM marketing3)) *100 AS `percent_of_marketing_expense`,

-- Percent of revenue
(CAST(revenue as double)/(SELECT SUM(revenue) FROM marketing3)) *100 AS `percent_of_total_revenue`	

FROM marketing2;

-- Adding a day column to the data --
ALTER TABLE marketing2
MODIFY COLUMN c_date DATE;

ALTER TABLE marketing2
ADD COLUMN day VARCHAR(10);

UPDATE marketing2
SET day = DAYNAME(c_date);





-- Step 3: Transferring all existent and calculated values in a seperate table for analysis -- 


 -- Creating table to store all KPIs calculated so far -- 
CREATE TABLE `marketing3` (
  `id` TEXT,
  `c_date` DATE DEFAULT NULL,
  `day` VARCHAR(10) DEFAULT NULL,
  `campaign_name` TEXT,
  `category` TEXT,
  `campaign_id` TEXT,
  `impressions` INT DEFAULT 0,
  `mark_spent` DOUBLE DEFAULT 0,
  `clicks` INT DEFAULT 0,
  `leads` INT DEFAULT 0,
  `orders` INT DEFAULT 0,
  `revenue` DOUBLE DEFAULT 0,
  `percent_of_total_orders` DOUBLE DEFAULT 0,
  `Profit` DOUBLE DEFAULT 0,
  `percent_of_total_profit` DOUBLE DEFAULT 0,
  `percentage_return_based_on_total_revenue` DOUBLE DEFAULT 0,
  `Average_Order_Value_AOV` DOUBLE DEFAULT 0,
  `ROI_per_dollar_profit` DOUBLE DEFAULT 0,
  `Customer_Acquisition_Cost_Cost_per_Lead` DOUBLE DEFAULT 0,
  `Click_through_rate_percent` DOUBLE DEFAULT 0,
  `Cost_per_click` DOUBLE DEFAULT 0,
  `percent_of_total_clicks` DOUBLE DEFAULT 0,
  `Revenue_per_click` DOUBLE DEFAULT 0,
  `percent_of_total_impressions` DOUBLE DEFAULT 0, 
  `percent_of_total_leads` DOUBLE DEFAULT 0, 
  `revenue_per_impression` DOUBLE DEFAULT 0,
  `revenue_per_100impressions` DOUBLE DEFAULT 0, 
  `revenue_per_1000impressions` DOUBLE DEFAULT 0, 
  `cost_per_impression` DOUBLE DEFAULT 0,
  `cost_per_100impressions` DOUBLE DEFAULT 0,
  `cost_per_1000impressions` DOUBLE DEFAULT 0, 
  `profit_per_impression` DOUBLE DEFAULT 0,
  `profit_per_100impressions` DOUBLE DEFAULT 0, 
  `profit_per_1000impressions` DOUBLE DEFAULT 0,
  `impressions_per_click` DOUBLE DEFAULT 0,
  `impressions_per_100clicks` DOUBLE DEFAULT 0,
  `impressions_per_1000clicks` DOUBLE DEFAULT 0, 
  `clicks_per_leads` DOUBLE DEFAULT 0, 
  `leads_per_click` DOUBLE DEFAULT 0,
  `orders_per_lead` DOUBLE DEFAULT 0, 
  `lead_per_order` DOUBLE DEFAULT 0, 
  `cost_per_order` DOUBLE DEFAULT 0,
  `per_dollar_contribution_to_order` DOUBLE DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Inserting calculated values into new table with case for division by 0 --	
INSERT INTO marketing3 (
  id, c_date, campaign_name, category, campaign_id, impressions, mark_spent, clicks, leads, orders, revenue,
  percent_of_total_orders, Profit, percent_of_total_profit, percentage_return_based_on_total_revenue,
  Average_Order_Value_AOV, ROI_per_dollar_profit, Customer_Acquisition_Cost_Cost_per_Lead,
  Click_through_rate_percent, Cost_per_click, percent_of_total_clicks, Revenue_per_click,
  day, percent_of_total_impressions, percent_of_total_leads, revenue_per_impression,
  revenue_per_100impressions, revenue_per_1000impressions, cost_per_impression,
  cost_per_100impressions, cost_per_1000impressions, profit_per_impression,
  profit_per_100impressions, profit_per_1000impressions, impressions_per_click,
  impressions_per_100clicks, impressions_per_1000clicks, clicks_per_leads, leads_per_click,
  orders_per_lead, lead_per_order, cost_per_order, per_dollar_contribution_to_order
)
SELECT
  id, c_date, campaign_name, category, campaign_id, impressions, mark_spent, clicks, leads, orders, revenue,
  day,

-- Percent of total orders
CASE 
    WHEN orders = 0 THEN 0
    ELSE
        (CAST(orders AS DOUBLE) / NULLIF((SELECT SUM(orders) FROM marketing2), 0)) * 100
END AS percent_of_total_orders,
 
-- Profit amount    
revenue - mark_spent AS `Profit`,

-- Percent of total profits	
((revenue - mark_spent) / NULLIF((SELECT SUM(revenue) - SUM(mark_spent) FROM marketing2), 0)) * 100 
AS percent_of_total_profit,

-- Profit return based on percent of total revenue
(revenue - mark_spent) / NULLIF((SELECT SUM(revenue) FROM marketing2), 0) * 100 
AS percentage_return_based_on_total_revenue,

-- Average Order Value 
CASE 
    WHEN orders = 0 THEN 0 
    ELSE revenue / orders 
  END AS `Average_Order_Value(AOV)`,
  
-- Return on Investment (ROI)  
((revenue - mark_spent) / NULLIF(mark_spent, 0)) * 100 AS ROI,
  -- how would you deal with it if mark_spent was 0 and revenue has $1000? (ROI)

-- Customer-Acquisition-Cost/Cost-per-Lead
  CASE 
    WHEN leads = 0 THEN 0 
    ELSE mark_spent / leads 
  END AS `Customer_Acquisition_Cost/Cost_per_Lead`,

-- Percent of Click-through-rate	
  CASE 
  WHEN impressions = 0 THEN 0 
  ELSE (CAST(clicks AS DOUBLE) / impressions) * 100 
END AS `Click_through_rate %`,

--Cost per Click
CASE 
    WHEN clicks = 0 THEN 0 
    ELSE mark_spent / clicks 
  END AS `Cost-per-click`,

-- Percent of total clicks	
  CASE
	WHEN clicks = 0 THEN 0 
	ELSE clicks/ NULLIF((SELECT SUM(clicks) FROM marketing2), 0) * 100 
 END AS percent_of_total_clicks,

-- Revenue earned per click	
  CASE 
    WHEN clicks = 0 THEN 0 
    ELSE revenue / clicks 
  END AS `Revenue-per-click`

 -- Percent of total impressions
  (CAST(impressions AS DOUBLE) / (SELECT SUM(impressions) FROM marketing3)) * 100
  AS percent_of_total_impressions, 
	  

  -- Percent of total leads
  (CAST(leads AS DOUBLE) / (SELECT SUM(leads) FROM marketing3)) * 100
     AS percent_of_total_leads,

  -- Revenue per impression
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (revenue / CAST(impressions AS DOUBLE))
    END 
   AS revenue_per_impression,

    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (revenue / CAST(impressions AS DOUBLE)) * 100
    END 
   AS revenue_per_100impressions,

    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (revenue / CAST(impressions AS DOUBLE)) * 1000
    END 
   AS revenue_per_1000impressions,

  -- Cost per impression
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE mark_spent / CAST(impressions AS DOUBLE)
    END 
  AS cost_per_impression,

    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (mark_spent / CAST(impressions AS DOUBLE)) * 100
    END 
   AS cost_per_100impressions,

    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (mark_spent / CAST(impressions AS DOUBLE)) * 1000
    END 
   AS cost_per_1000impressions,

  -- Profit per impression
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE profit / CAST(impressions AS DOUBLE)
    END 
  AS profit_per_impression,

  CAST(
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (profit / CAST(impressions AS DOUBLE)) * 100
    END 
  AS DOUBLE) AS profit_per_100impressions,

  CAST(
    CASE 
      WHEN impressions = 0 THEN 0
      ELSE (profit / CAST(impressions AS DOUBLE)) * 1000
    END 
  AS DOUBLE) AS profit_per_1000impressions,

  -- Impressions per click
    CASE 
      WHEN clicks = 0 THEN 0
      ELSE impressions / CAST(clicks AS DOUBLE)
    END 
  AS impressions_per_click,

    CASE 
      WHEN clicks = 0 THEN 0
      ELSE (impressions / CAST(clicks AS DOUBLE)) * 100
    END 
  AS impressions_per_100clicks,

    CASE 
      WHEN clicks = 0 THEN 0
      ELSE (impressions / CAST(clicks AS DOUBLE)) * 1000
    END 
  AS impressions_per_1000clicks,

  -- Clicks per lead
    CASE 
      WHEN leads = 0 THEN 0
      ELSE clicks / CAST(leads AS DOUBLE)
    END 
  AS clicks_per_leads,

  -- Leads per click
    CASE 
      WHEN clicks = 0 THEN 0
      ELSE leads / CAST(clicks AS DOUBLE)
    END 
   AS leads_per_click,

  -- Orders per lead
    CASE 
      WHEN leads = 0 THEN 0
      ELSE orders / CAST(leads AS DOUBLE)
    END 
   AS orders_per_lead,

  -- Leads per order
    CASE 
      WHEN orders = 0 THEN 0
      ELSE leads / CAST(orders AS DOUBLE)
    END 
   AS lead_per_order,

  -- Cost per order
    CASE 
      WHEN orders = 0 THEN 0
      ELSE mark_spent / CAST(orders AS DOUBLE)
    END 
   AS cost_per_order,

  -- Per-dollar contribution to order
    CASE 
      WHEN mark_spent = 0 THEN 0
      ELSE orders / CAST(mark_spent AS DOUBLE)
    END 
   AS per_dollar_contribution_to_order,
   
 -- Percent of marketing expense  
(CAST(mark_spent as double)/(SELECT SUM(mark_spent) FROM marketing3)) *100 AS `percent_of_marketing_expense`,

-- Percent of revenue
(CAST(revenue as double)/(SELECT SUM(revenue) FROM marketing3)) *100 AS `percent_of_total_revenue`	

FROM marketing2;

SELECT *
FROM marketing3;


-- Chaning column positions for smoother comparisons and analysis
ALTER TABLE marketing3
  MODIFY COLUMN `percent_of_total_impressions` DOUBLE AFTER `impressions`,
  MODIFY COLUMN `percent_of_total_orders` DOUBLE AFTER `orders`,
  MODIFY COLUMN `percent_of_total_clicks` DOUBLE AFTER `clicks`,
  MODIFY COLUMN `percent_of_total_leads` DOUBLE AFTER `leads`,
  MODIFY COLUMN `percent_of_marketing_expense` DOUBLE AFTER `mark_spent`,
  MODIFY COLUMN `percent_of_total_revenue` DOUBLE AFTER `revenue`;


