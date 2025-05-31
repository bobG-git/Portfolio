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

USE sales;

CREATE TABLE marketing2
LIKE marketing;

INSERT INTO marketing2
SELECT *
FROM marketing;

SELECT campaign_name, SUM(mark_spent)/ SUM(leads) AS CAC, 
(((SUM(revenue) - SUM(mark_spent))/SUM(mark_spent))*100) AS ROI
FROM marketing2
GROUP BY campaign_name;

SELECT *, mark_spent/leads AS `Customer-Acquisition-Cost`, ((revenue - mark_spent)/mark_spent) * 100 AS ROI,
(CAST(clicks AS FLOAT)/impressions)*100 AS `Click-through-rate`,
mark_spent/clicks AS `Cost-per-click`, mark_spent/leads AS `Cost-per-lead`,
revenue/clicks AS `Revenue-per-click`
FROM marketing2;

WITH CTE AS
(SELECT *, mark_spent/leads AS `Customer-Acquisition-Cost`, ((revenue - mark_spent)/mark_spent) * 100 AS ROI,
(CAST(clicks AS FLOAT)/impressions)*100 AS `Click-through-rate`,
mark_spent/clicks AS `Cost-per-click`, mark_spent/leads AS `Cost-per-lead`,
revenue/clicks AS `Revenue-per-click`
FROM marketing2)
WITH CTE AS (
  SELECT *, 
         mark_spent / leads AS `Customer-Acquisition-Cost`, 
         ((revenue - mark_spent) / mark_spent) * 100 AS `ROI`,
         (CAST(clicks AS FLOAT) / impressions) * 100 AS `Click-through-rate`,
         mark_spent / clicks AS `Cost-per-click`, 
         mark_spent / leads AS `Cost-per-lead`,
         revenue / clicks AS `Revenue-per-click`
  FROM marketing2
)
SELECT *
FROM CTE
WHERE
  id IS NULL OR
  c_date IS NULL OR
  campaign_name IS NULL OR
  category IS NULL OR
  campaign_id IS NULL OR
  impressions IS NULL OR
  mark_spent IS NULL OR
  clicks IS NULL OR
  leads IS NULL OR
  orders IS NULL OR
  revenue IS NULL OR
  `Customer-Acquisition-Cost` IS NULL OR
  `ROI` IS NULL OR
  `Click-through-rate` IS NULL OR
  `Cost-per-click` IS NULL OR
  `Cost-per-lead` IS NULL OR
  `Revenue-per-click` IS NULL;
  
  SELECT *
FROM (
  SELECT *, 
         mark_spent / leads AS `Customer-Acquisition-Cost`, 
         ((revenue - mark_spent) / mark_spent) * 100 AS ROI,
         (CAST(clicks AS FLOAT) / impressions) * 100 AS `Click-through-rate`,
         mark_spent / clicks AS `Cost-per-click`, 
         mark_spent / leads AS `Cost-per-lead`,
         revenue / clicks AS `Revenue-per-click`
  FROM marketing2
) AS sub
WHERE
  id IS NULL OR
  c_date IS NULL OR
  campaign_name IS NULL OR
  category IS NULL OR
  campaign_id IS NULL OR
  impressions IS NULL OR
  mark_spent IS NULL OR
  clicks IS NULL OR
  leads IS NULL OR
  orders IS NULL OR
  revenue IS NULL OR
  `Customer-Acquisition-Cost` IS NULL OR
  ROI IS NULL OR
  `Click-through-rate` IS NULL OR
  `Cost-per-click` IS NULL OR
  `Cost-per-lead` IS NULL OR
  `Revenue-per-click` IS NULL;



DROP TABLE marketing3;

CREATE TABLE `marketing3` (
  `id` int DEFAULT NULL,
  `c_date` text,
  `campaign_name` text,
  `category` text,
  `campaign_id` text,
  `impressions` int DEFAULT NULL,
  `mark_spent` double DEFAULT NULL,
  `clicks` int DEFAULT NULL,
  `leads` int DEFAULT NULL,
  `orders` int DEFAULT NULL,
  `revenue` double DEFAULT NULL,
  `Customer-Acquisition-Cost`double DEFAULT NULL,
  `ROI` double DEFAULT NULL,
  `Click-through-rate` double DEFAULT NULL,
  `Cost-per-click` double DEFAULT NULL,
  `Cost-per-lead` double DEFAULT NULL,
  `Revenue-per-click` double DEFAULT NULL
  
  
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM
marketing3;

INSERT INTO marketing3
SELECT *, mark_spent/leads AS `Customer-Acquisition-Cost`, ((revenue - mark_spent)/mark_spent) * 100 AS ROI,
(CAST(clicks AS FLOAT)/impressions)*100 AS `Click-through-rate`,
mark_spent/clicks AS `Cost-per-click`, mark_spent/leads AS `Cost-per-lead`,
revenue/clicks AS `Revenue-per-click`
FROM marketing2;

INSERT INTO marketing3
SELECT 
  *,
  mark_spent / NULLIF(leads, 0) AS `Customer-Acquisition-Cost`,
  ((revenue - mark_spent) / NULLIF(mark_spent, 0)) * 100 AS ROI,
  (CAST(clicks AS FLOAT) / NULLIF(impressions, 0)) * 100 AS `Click-through-rate`,
  mark_spent / NULLIF(clicks, 0) AS `Cost-per-click`,
  mark_spent / NULLIF(leads, 0) AS `Cost-per-lead`,
  revenue / NULLIF(clicks, 0) AS `Revenue-per-click`
FROM marketing2;

SELECT *
FROM marketing3;




SELECT revenue/clicks AS RPC
FROM marketing2;

SELECT *, 

SELECT COUNT(DISTINCT campaign_name)
FROM marketing2;

SELECT clicks, impressions, (clicks/impressions) * 100, 
(CAST(clicks AS FLOAT)/impressions)*100, (clicks /CAST(impressions AS FLOAT)*100)
FROM marketing2;

SELECT SUM(leads), SUM(mark_spent)
FROM marketing2
WHERE campaign_name = 'facebook_tier1';

SELECT *
FROM marketing2;

INSERT INTO marketing3
SELECT *, mark_spent/leads AS `Customer-Acquisition-Cost`, ((revenue - mark_spent)/mark_spent) * 100 AS ROI,
(CAST(clicks AS FLOAT)/impressions)*100 AS `Click-through-rate`,
mark_spent/clicks AS `Cost-per-click`, mark_spent/leads AS `Cost-per-lead`,
revenue/clicks AS `Revenue-per-click`
FROM marketing2;

USE sales;

# AVERAGE ORDER VALUE(AOV): AVERAGE VALUE OF AN ORDER IN A CONTEXT
-- THE CONTEXT IN AOV THIS TIME IS CAMPAIGN NAME. I.E AVERAGE 
WITH CTE4 AS 
(
SELECT campaign_name, 
SUM(revenue) AS total_revenue, 
SUM(orders) AS total_orders,   
SUM(revenue) / NULLIF(SUM(orders), 0) AS average_order_value
FROM marketing 
GROUP BY campaign_name
-- ORDER BY total_orders DESC;
)
SELECT * 
-- AVG(total_orders) OVER () AS overall_avg, 
-- AVG(average_order_value) OVER() AS overall_avg_avg_value
FROM CTE4
WHERE average_order_value < 4729.002492019766;
-- AND total_orders/COUNT(total_orders) > 731.1818;

SELECT campaign_id, 
SUM(revenue) AS total_revenue, 
SUM(orders) AS total_orders, 
SUM(revenue) / NULLIF(SUM(orders), 0) AS average_order_value 
FROM marketing 
GROUP BY campaign_id;
-- profit_percentage_based_on_cost (ROI)
-- the percent of which return(profit/loss) is greater/less
-- than the cost/ the amount invested. 
-- FORMULA: ((S.P - C.P)/C.P) * 100
-- return based on cost

-- profit_percentage_based_on_revenue
-- the percentage of which return(profit/loss) is greater/less 
-- than the revenue generated by the product.
-- FORMULA: ((S.P - C.P)/S.P) * 100
-- return based on revenue
SELECT campaign_id, category,
 SUM(revenue) AS total_revenue, 
 (SUM(revenue) / NULLIF((SELECT SUM(revenue) FROM marketing2), 0)) * 100 AS percent_of_total_revenue,
 SUM(mark_spent) AS total_marketing_spent,
 (SUM(mark_spent) / NULLIF((SELECT SUM(mark_spent) FROM marketing2), 0)) * 100 AS percent_of_total_markt_spent,
 SUM(revenue) - SUM(mark_spent) AS profit,
 ((SUM(revenue) - SUM(mark_spent)) / NULLIF((SELECT SUM(revenue) - SUM(mark_spent) FROM marketing2), 0)) * 100 AS percent_of_total_profit,
 ((SUM(revenue) - SUM(mark_spent)) / NULLIF(SUM(mark_spent), 0)) * 100 AS roi, 
 ((SUM(revenue) - SUM(mark_spent)) / NULLIF(SUM(revenue), 0)) * 100 AS percentage_return_based_on_revenue,
 SUM(orders) AS total_orders,
 (SUM(orders) / NULLIF((SELECT SUM(orders) FROM marketing2), 0)) * 100 AS percent_of_total_orders,
  SUM(clicks) AS total_clicks,
(SUM(clicks) / NULLIF((SELECT SUM(clicks) FROM marketing2), 0)) * 100 AS percent_of_total_clicks
 FROM marketing2
 GROUP BY campaign_id, category
 ORDER BY category DESC;

SELECT *, 
CASE 
  WHEN leads = 0 THEN 0
  ELSE mark_spent/leads
END AS `Customer-Acquisition-Cost/Cost-per-Lead`,
((revenue - mark_spent) / NULLIF(mark_spent, 0)) * 100 AS `ROI / per-dollar-profit`,
(CAST(clicks AS FLOAT)/impressions)*100 AS `Click-through-rate %`,
mark_spent/clicks AS `Cost-per-click`,
revenue/clicks AS `Revenue-per-click`,
CASE 
  WHEN orders = 0 THEN 0
  ELSE revenue / orders
END AS `Profit_Amount`

FROM marketing2

WHERE mark_spent > 100000;

SELECT *
FROM marketing2;

SELECT category, campaign_id
FROM marketing2
CROSS JOIN marketing2;

WITH CTE AS
(
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
  
FROM marketing2
)

SELECT 
  -- SUM(CASE WHEN percent_of_total_profit < 0 THEN percent_of_total_profit ELSE 0 END) AS ABC,
--   SUM(CASE WHEN percent_of_total_profit > 0 THEN percent_of_total_profit ELSE 0 END) AS ABCD
*
FROM CTE;

CREATE TABLE `marketing3` (
  `id` text,
  `c_date` text,
  `campaign_name` text,
  `category` text,
  `campaign_id` text,
  `impressions` int DEFAULT NULL,
  `mark_spent` double DEFAULT NULL,
  `clicks` int DEFAULT NULL,
  `leads` int DEFAULT NULL,
  `orders` int DEFAULT NULL,
  `revenue` double DEFAULT NULL,
  `percent_of_total_orders`double DEFAULT 0, 
  `Profit` double DEFAULT 0, 
  `percent_of_total_profit` double DEFAULT 0, 
  `percentage_return_based_on_total_revenue`double DEFAULT 0, 
  `Average_Order_Value(AOV)` double DEFAULT 0,
  `ROI` double DEFAULT 0,
  `Customer_Acquisition_Cost/Cost_per_Lead` double DEFAULT 0, 
  `Click_through_rate %` double DEFAULT 0, 
  `Cost_per_click` double DEFAULT 0, 
  `percent_of_total_clicks` double DEFAULT 0, 
  `Revenue_per_click` double DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO marketing3
SELECT *,

  CASE 
    WHEN orders = 0 THEN 0
    ELSE (CAST(orders AS DOUBLE) / NULLIF((SELECT SUM(orders) FROM marketing2), 0)) * 100
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

  CASE 
    WHEN leads = 0 THEN 0 
    ELSE mark_spent / leads 
  END AS `Customer_Acquisition_Cost/Cost_per_Lead`,

  CASE 
    WHEN impressions = 0 THEN 0 
    ELSE (CAST(clicks AS DOUBLE) / impressions) * 100 
  END AS `Click_through_rate %`,

  CASE 
    WHEN clicks = 0 THEN 0 
    ELSE mark_spent / clicks 
  END AS `Cost_per_click`,

  CASE
    WHEN clicks = 0 THEN 0 
    ELSE clicks / NULLIF((SELECT SUM(clicks) FROM marketing2), 0) * 100 
  END AS percent_of_total_clicks,

  CASE 
    WHEN clicks = 0 THEN 0 
    ELSE revenue / clicks 
  END AS `Revenue_per_click`

FROM marketing2;


SELECT *,
impressions / NULLIF((SELECT SUM(impressions) FROM marketing3), 0) * 100  AS percent_of_total_impressions,
leads / NULLIF((SELECT SUM(leads) FROM marketing3), 0) * 100 AS percent_of_total_leads,
revenue / impressions AS revenue_per_impression
FROM marketing3;


SELECT 
campaign_id,
  SUM(impressions) AS total_impressions,
  SUM(leads) AS total_leads,
  SUM(revenue) AS total_revenue,

  -- Calculate percentage of total impressions
  (SUM(impressions) / NULLIF((SELECT SUM(impressions) FROM marketing3), 0)) * 100 AS percent_of_total_impressions,

  -- Calculate percentage of total leads
  (SUM(leads) / NULLIF((SELECT SUM(leads) FROM marketing3), 0)) * 100 AS percent_of_total_leads,

  -- Revenue per impression
  (SUM(revenue) / NULLIF(SUM(impressions), 0)) AS revenue_per_impression,
  (SUM(revenue) / NULLIF(SUM(impressions), 0)) * 100 AS revenue_per_100impressions,
  (SUM(revenue) / NULLIF(SUM(impressions), 0)) * 1000 AS revenue_per_1000impressions,
  
  (SUM(mark_spent) / NULLIF(SUM(impressions), 0)) AS cost_per_impression,
  (SUM(mark_spent) / NULLIF(SUM(impressions), 0)) * 100 AS cost_per_100impressions,
  (SUM(mark_spent) / NULLIF(SUM(impressions), 0)) * 1000 AS cost_per_1000impressions,
  
  (SUM(profit) / NULLIF(SUM(impressions), 0)) AS profit_per_impression,
  (SUM(profit) / NULLIF(SUM(impressions), 0)) * 100 AS profit_per_100impressions,
  (SUM(profit) / NULLIF(SUM(impressions), 0)) * 1000 AS profit_per_1000impressions

FROM marketing3
GROUP BY campaign_id;



SELECT *,

  -- Calculate percentage of total impressions
  impressions / NULLIF((SELECT SUM(impressions) FROM marketing3), 0) * 100 AS percent_of_total_impressions,

  -- Calculate percentage of total leads
  leads / NULLIF((SELECT SUM(leads) FROM marketing3), 0)* 100 AS percent_of_total_leads,

  -- Revenue per impression
  revenue / impressions  AS revenue_per_impression,
  (revenue / impressions) * 100 AS revenue_per_100impressions,
  (revenue / impressions) * 1000 AS revenue_per_1000impressions,
  
  (mark_spent) / (impressions) AS cost_per_impression,
  (mark_spent / impressions) * 100 AS cost_per_100impressions,
  (mark_spent / impressions) * 1000 AS cost_per_1000impressions,
  
  (profit) / (impressions) AS profit_per_impression,
  (profit / impressions) * 100 AS profit_per_100impressions,
  (profit / impressions) * 1000 AS profit_per_1000impressions,
  
  impressions / CAST(clicks AS DOUBLE) AS impressions_per_click,
  (impressions / CAST(clicks AS DOUBLE)) * 100 AS impressions_per_100clicks,
  (impressions  / CAST(clicks AS DOUBLE))  * 1000 AS impressions_per_1000clicks,

(clicks / CAST(leads AS DOUBLE))  AS `clicks-per-leads`,

(leads / CAST(clicks AS DOUBLE))  AS `leads-per-click`,

(orders  / CAST(leads AS DOUBLE))  AS `orders-per-lead`,

(leads / CAST(orders AS DOUBLE))  AS `lead-per-order`,

(mark_spent/ CAST(orders AS DOUBLE))  AS `cost-per-order`,

(orders/ CAST(mark_spent AS DOUBLE))  AS `per-dollar-contribution-to-order`



FROM marketing3;
-- WHERE profit >= 0;
-- WHERE campaign_name = 'google_hot
-- ORDER BY Profit DESC;


-- group by days
ALTER TABLE marketing3
MODIFY COLUMN c_date DATE;

SELECT *
FROM marketing3
WHERE revenue = 0
AND mark_spent = 0;

select *
from marketing3;

ALTER TABLE marketing3
CHANGE COLUMN ROI `ROI / per-dollar-profit` DOUBLE;


ALTER TABLE marketing3
ADD COLUMN day VARCHAR(10);

UPDATE marketing3
SET day = DAYNAME(c_date);

SELECT COUNT(*) AS column_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'sales'
  AND table_name = 'marketing3';
  
  id, c_date, campaign_name, category, campaign_id, 
  impressions, mark_spent, clicks, leads, orders, revenue, 
  percent_of_total_orders, Profit, percent_of_total_profit, 
  percentage_return_based_on_total_revenue, Average_Order_Value(AOV), 
  ROI / per-dollar-profit, Customer_Acquisition_Cost/Cost_per_Lead, 
  Click_through_rate %, Cost_per_click, percent_of_total_clicks, 
  Revenue_per_click, day, percent_of_total_impressions, percent_of_total_leads, 
  revenue_per_impression, revenue_per_100impressions, revenue_per_1000impressions, 
  cost_per_impression, cost_per_100impressions, cost_per_1000impressions, 
  profit_per_impression, profit_per_100impressions, profit_per_1000impressions, 
  impressions_per_click, impressions_per_100clicks, impressions_per_1000clicks, 
  clicks-per-leads, leads-per-click, orders-per-lead, lead-per-order, cost-per-order,
  per-dollar-contribution-to-order
  
  
  CREATE TABLE `marketing4` (
  `id` text,
  `c_date` date DEFAULT NULL,
  `day` varchar(10) DEFAULT NULL,
  `campaign_name` text,
  `category` text,
  `campaign_id` text,
  `impressions` int DEFAULT NULL,
  `mark_spent` double DEFAULT NULL,
  `clicks` int DEFAULT NULL,
  `leads` int DEFAULT NULL,
  `orders` int DEFAULT NULL,
  `revenue` double DEFAULT NULL,
  `percent_of_total_orders` double DEFAULT '0',
  `Profit` double DEFAULT '0',
  `percent_of_total_profit` double DEFAULT '0',
  `percentage_return_based_on_total_revenue` double DEFAULT '0',
  `Average_Order_Value(AOV)` double DEFAULT '0',
  `ROI / per-dollar-profit` double DEFAULT NULL,
  `Customer_Acquisition_Cost/Cost_per_Lead` double DEFAULT '0',
  `Click_through_rate %` double DEFAULT '0',
  `Cost_per_click` double DEFAULT '0',
  `percent_of_total_clicks` double DEFAULT '0',
  `Revenue_per_click` double DEFAULT '0',
  `percent_of_total_impressions` double DEFAULT '0', 
  `percent_of_total_leads` double DEFAULT '0', 
  `revenue_per_impression` double DEFAULT '0',
  `revenue_per_100impressions` double DEFAULT '0', 
  `revenue_per_1000impressions` double DEFAULT '0', 
  `cost_per_impression` double DEFAULT '0',
  `cost_per_100impressions` double DEFAULT '0',
  `cost_per_1000impressions` double DEFAULT '0', 
  `profit_per_impression` double DEFAULT '0',
  `profit_per_100impressions` double DEFAULT '0', 
  `profit_per_1000impressions` double DEFAULT '0',
  `impressions_per_click` double DEFAULT '0',
  `impressions_per_100clicks` double DEFAULT '0',
  `impressions_per_1000clicks` double DEFAULT '0', 
  `clicks_per_leads` double DEFAULT '0', 
  `leads_per_click` double DEFAULT '0',
  `orders_per_lead` double DEFAULT '0', 
  `lead_per_order` double DEFAULT '0', 
  `cost_per_order` double DEFAULT '0',
  `per_dollar_contribution_to_order` double DEFAULT '0'
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `marketing4` (
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

INSERT INTO marketing4 (
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
  percent_of_total_orders, Profit, percent_of_total_profit, percentage_return_based_on_total_revenue,
  `Average_Order_Value(AOV)`, `ROI / per-dollar-profit`, `Customer_Acquisition_Cost/Cost_per_Lead`,
  `Click_through_rate %`, Cost_per_click, percent_of_total_clicks, Revenue_per_click,
  day,

  impressions / NULLIF((SELECT SUM(impressions) FROM marketing3), 0) * 100,
  leads / NULLIF((SELECT SUM(leads) FROM marketing3), 0) * 100,

  revenue / NULLIF(impressions, 0),
  (revenue / NULLIF(impressions, 0)) * 100,
  (revenue / NULLIF(impressions, 0)) * 1000,

  mark_spent / NULLIF(impressions, 0),
  (mark_spent / NULLIF(impressions, 0)) * 100,
  (mark_spent / NULLIF(impressions, 0)) * 1000,

  profit / NULLIF(impressions, 0),
  (profit / NULLIF(impressions, 0)) * 100,
  (profit / NULLIF(impressions, 0)) * 1000,

  impressions / NULLIF(CAST(clicks AS DOUBLE), 0),
  (impressions / NULLIF(CAST(clicks AS DOUBLE), 0)) * 100,
  (impressions / NULLIF(CAST(clicks AS DOUBLE), 0)) * 1000,

  clicks / NULLIF(CAST(leads AS DOUBLE), 0),
  leads / NULLIF(CAST(clicks AS DOUBLE), 0),
  orders / NULLIF(CAST(leads AS DOUBLE), 0),
  leads / NULLIF(CAST(orders AS DOUBLE), 0),
  mark_spent / NULLIF(CAST(orders AS DOUBLE), 0),
  orders / NULLIF(CAST(mark_spent AS DOUBLE), 0)

FROM marketing3;

SELECT *
FROM marketing4;

SELECT *
FROM marketing3;

ALTER TABLE marketing4
  MODIFY COLUMN `percent_of_total_impressions` DOUBLE AFTER `impressions`;


SELECT *
FROM marketing3;








