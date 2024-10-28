SELECT * FROM Carbon_Emission

-- Check for NULL values in any columns.

SELECT * FROM Carbon_Emission
WHERE "CO2 emission estimates" IS NULL

SELECT * FROM Carbon_Emission
WHERE Year IS NULL

SELECT * FROM Carbon_Emission
WHERE Series IS NULL

SELECT * FROM Carbon_Emission
WHERE Value IS NULL

-- Checking the smaller parts of the dataset.

SELECT MIN(Year), MAX(Year) 
FROM Carbon_Emission 

SELECT DISTINCT Series
FROM Carbon_Emission 

SELECT MIN(Value), MAX(Value) 
FROM Carbon_Emission 
WHERE Series = 'Emissions (thousand metric tons of carbon dioxide)'

SELECT MIN(Value), MAX(Value) 
FROM Carbon_Emission 
WHERE Series = 'Emissions per capita (metric tons of carbon dioxide)'

-- Here 'Series' column has 2 distinct values.
-- By breaking these value into 2 tables, our work will be easier.

CREATE TABLE Emissions_thousand
(Country nvarchar(50), Year int,
Series nvarchar(100), Value float)

-- Inserting values from the Carbon Emission table where 
-- Series = 'Emissions (thousand metric tons of carbon dioxide)' into the Emissions_thousand table.

INSERT INTO Emissions_thousand 
SELECT * FROM Carbon_Emission WHERE 
Series = 'Emissions (thousand metric tons of carbon dioxide)'

-- Creating a new table where Series = 'Emissions per capita (metric tons of carbon dioxide)'

CREATE TABLE Emissions_perCapita
(Country nvarchar(50), Year int,
Series nvarchar(100), Value float)

-- Inserting values from the Carbon Emission table where Series = 'Emissions per capita (metric tons of carbon dioxide)' into the Emissions_perCapita table.

INSERT INTO Emissions_perCapita 
SELECT * FROM Carbon_Emission WHERE 
Series = 'Emissions per capita (metric tons of carbon dioxide)'

-- Finding data about United States of America only from Emissions_perCapita table.
-- But first, we need to know how United States of America is feeded in the table.

SELECT DISTINCT Country FROM Emissions_perCapita 
WHERE Country LIKE 'U%'

-- Finding the min and max value of Carbon Emissions per capita in United States of America.

SELECT MIN(Value) as min_value, MAX(Value) as max_value 
from Emissions_perCapita WHERE 
Country = 'United States of America'

-- The min value is 14.606 & the max value is 20.168.
-- Finding the Year with min & max value of Carbon Emissions per capital in USA.

SELECT YEAR FROM Emissions_perCapita 
WHERE Country = 'United States of America' AND Value IN (20.168, 14.606)

-- The year for max value(20.168) is 1975 and the year for min value(14.606) is 2017.
-- Next, comparing the changes in emissions per capital in the year 2017 to 1975.

WITH Value1975 AS (
    SELECT Country, Value AS old_value
    FROM Emissions_perCapita
    WHERE Year = 1975),
Value2017 AS (
    SELECT Country, Value AS new_value
    FROM Emissions_perCapita
    WHERE Year = 2017)
SELECT Value1975.Country,
    Value1975.old_value,
    Value2017.new_value FROM Value1975
JOIN Value2017 ON Value1975.Country = Value2017.Country;

-- Now moving on the Emissions_thousand table to find the min & max values of USA.

SELECT * FROM Emissions_thousand

SELECT MIN(Value) as mini_value, MAX(Value) as maxi_value 
FROM Emissions_thousand WHERE 
Country = 'United States of America'

-- The min value is 4355839.181 & the max value is 5703220.175.
-- Finding the Year with min & max value of Carbon Emissions per capital in USA.

SELECT Year FROM Emissions_thousand 
WHERE Country = 'United States of America' 
AND Value IN (4355839.181,5703220.175)

-- The year for max value(4355839.181) is 2005 and the year for min value(5703220.175) is 1975.
-- Finding Top 5 countries having the highest amount of Carbon Emission.

SELECT "CO2 emission estimates", SUM(Value) AS sum_value
FROM Carbon_Emission
GROUP BY "CO2 emission estimates"
ORDER BY sum_value DESC
LIMIT 5;

-- China, United States of America, India, Russian Federation, Japan.
-- Finding the year in which United States of America emitted the highest amount of CO2.

SELECT Year, Value FROM Carbon_Emission 
WHERE "CO2 emission estimates" = "United States of America" 
ORDER BY Value DESC LIMIT 1

-- United States of America emitted the highest amount of CO2 in 2005.
