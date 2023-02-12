
-- Products have different units of measurement and the most common on is oz (60% of products). To compare the same units of measurement, I created a column with "price_per_oz", where I devide the regular price by the volume. --
-- I created 4 columns: sum_badges, subcatgory, average_price_per_oz and products_with badge (which is a count of products with that specific amount of badges in the subcategory). I then displayed only the subcategories that contain more than 20 products to provide a statistically meaningful analysis. I made sure select distinct product id to avoid analyzing duplicates -- 

USE bos_ddmban_sql_analysis;
WITH new_table AS 
(SELECT *,
FORMAT(regular_price / volume, 2) AS 'price_per_oz'
FROM bmbandd_data
WHERE volume_of_measurement = 'oz')
SELECT 
   sum_badges,
   subcategory, 
   CASE WHEN sum_badges = 0 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 1 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 2 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 3 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 4 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 5 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 6 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 7 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 8 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 9 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 10 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 11 THEN FORMAT (AVG(`price_per_oz`), 2)
        WHEN sum_badges = 12 THEN FORMAT (AVG(`price_per_oz`), 2)
END AS 'average_price_per_oz',
COUNT(wf_product_id) AS 'products_with_badge'
FROM new_table
GROUP BY sum_badges, subcategory
-- only subcategories with more than 20 products to make the analysis consistent -- 
HAVING subcategory IN 
       (SELECT subcategory
       FROM new_table
       GROUP BY subcategory
       HAVING COUNT(DISTINCT wf_product_id) > 20)
ORDER BY sum_badges, subcategory  
;



-- Union the queries with the different dietary preferences (badge) while only considering the subcategories with more than 20 products to keep the statistical analysis consistent. I then calculated the standard deviation for all the considered subcategories, both in the case of existing or non existing badge. I made sure select distinct product id to avoid analyzing duplicates--

USE bos_ddmban_sql_analysis;
WITH new_table AS (
SELECT *,
FORMAT(regular_price / volume, 2) AS 'price_per_weight'
FROM bmbandd_data
WHERE volume_of_measurement = 'oz')
SELECT subcategory,
       'is_vegan' AS badge,
       CASE WHEN is_vegan = 1 THEN 'vegan'ELSE 'not_vegan' 
	   END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_vegan
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20
                              )
UNION 
SELECT subcategory, 
	   'is_keto_friendly' AS badge, 
       CASE WHEN is_keto_friendly = 1 THEN 'keto_friendly' ELSE 'not_keto_friendly'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
	   ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_keto_friendly
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION 
SELECT subcategory, 
	   'is_paleo_friendly' AS badge, 
       CASE WHEN is_paleo_friendly = 1 THEN 'paleo_friendly' ELSE 'not_paleo_friendly'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
	   ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_paleo_friendly
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION 
    SELECT subcategory, 
	   'is_gluten_free' AS badge,
       CASE WHEN is_gluten_free = 1 THEN 'gluten_free' ELSE 'not_gluten_free'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
	   ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_gluten_free
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION 
   SELECT subcategory, 
	   'is_vegetarian' AS badge, 
       CASE WHEN is_vegetarian = 1 THEN 'vegetarian' ELSE 'not_vegetarian'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_vegetarian
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION                        
	SELECT subcategory, 
	   'is_kosher' AS badge, 
       CASE WHEN is_kosher = 1 THEN 'kosher' ELSE 'not_kosher'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_kosher
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION       					
	SELECT subcategory, 
	   'is_sugar_conscious' AS badge, 
       CASE WHEN is_sugar_conscious = 1 THEN 'sugar_conscious' ELSE 'not_sugar_conscious'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_sugar_conscious
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION       					
	SELECT subcategory, 
	   'is_dairy_free' AS badge,
       CASE WHEN is_dairy_free = 1 THEN 'dairy_free' ELSE 'not_dairy_free'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_dairy_free
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION       												
	SELECT subcategory, 
	   'is_high_fiber' AS badge,
       CASE WHEN is_high_fiber = 1 THEN 'high_fiber' ELSE 'not_high_fiber'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_high_fiber
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION
    SELECT subcategory, 
	   'is_engine_2' AS badge,
       CASE WHEN is_engine_2 = 1 THEN 'engine_2' ELSE 'not_engine_2'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_engine_2
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION
    SELECT subcategory, 
	   'is_low_sodium' AS badge,
       CASE WHEN is_low_sodium = 1 THEN 'low_sodium' ELSE 'low_sodium'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_low_sodium
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION
    SELECT subcategory, 
	   'is_low_fat' AS badge,
       CASE WHEN is_low_fat = 1 THEN 'low_fat' ELSE 'not_low_fat'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_low_fat
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION
    SELECT subcategory, 
	   'is_wheat_free' AS badge,
       CASE WHEN is_wheat_free = 1 THEN 'wheat_free' ELSE 'not_wheat_free'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_wheat_free
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION
    SELECT subcategory, 
	   'is_organic' AS badge,
       CASE WHEN is_organic = 1 THEN 'organic' ELSE 'not_organic'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_organic
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION
SELECT subcategory, 
	   'is_whole_foods_diet' AS badge,
       CASE WHEN is_whole_foods_diet = 1 THEN 'whole_foods_diet' ELSE 'not_whole_foods_diet'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_whole_foods_diet
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION
 SELECT subcategory, 
	   'is_others' AS badge,
       CASE WHEN is_others = 1 THEN 'others' ELSE 'not_others'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_others
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
UNION
 SELECT subcategory, 
	   'is_no_badge' AS badge,
       CASE WHEN is_no_badge = 1 THEN 'no_badge' ELSE 'yes_badge'
END AS 'badge_status',
       FORMAT(AVG(`price_per_weight`), 2) AS 'price_per_oz',
       ROUND(STDDEV_SAMP(`price_per_weight`), 2) AS standard_deviation,
       COUNT(*) AS n_of_products
       FROM new_table
       GROUP BY subcategory, is_no_badge
       HAVING subcategory IN (
                              SELECT subcategory
                              FROM new_table
                              GROUP BY subcategory
                              HAVING COUNT(DISTINCT wf_product_id) > 20)
;