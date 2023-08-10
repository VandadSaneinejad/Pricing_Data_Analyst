CREATE VIEW `Distance Bucket` AS
SELECT
    'A' AS City,
    1 AS "Service Type",
    '6/22/2022' AS "Created Date",
    CASE
        WHEN inv.Distance BETWEEN 0 AND 1 THEN '0-1'
        WHEN inv.Distance BETWEEN 1 AND 2 THEN '1-2'
        WHEN inv.Distance BETWEEN 2 AND 3 THEN '2-3'
        WHEN inv.Distance BETWEEN 3 AND 4 THEN '3-4'
        WHEN inv.Distance BETWEEN 4 AND 5 THEN '4-5'
        WHEN inv.Distance BETWEEN 5 AND 6 THEN '5-6'
        WHEN inv.Distance BETWEEN 6 AND 7 THEN '6-7'
        WHEN inv.Distance BETWEEN 7 AND 8 THEN '7-8'
        WHEN inv.Distance BETWEEN 8 AND 9 THEN '8-9'
        WHEN inv.Distance BETWEEN 9 AND 10 THEN '9-10'
        WHEN inv.Distance BETWEEN 10 AND 11 THEN '10-11'
        WHEN inv.Distance BETWEEN 11 AND 12 THEN '11-12'
        WHEN inv.Distance BETWEEN 12 AND 13 THEN '12-13'
        WHEN inv.Distance BETWEEN 13 AND 14 THEN '13-14'
        WHEN inv.Distance BETWEEN 14 AND 15 THEN '14-15'
        WHEN inv.Distance BETWEEN 15 AND 16 THEN '15-16'
        WHEN inv.Distance BETWEEN 16 AND 17 THEN '16-17'
        WHEN inv.Distance BETWEEN 17 AND 18 THEN '17-18'
        WHEN inv.Distance BETWEEN 18 AND 19 THEN '18-19'
        WHEN inv.Distance BETWEEN 19 AND 20 THEN '19-20'
        WHEN inv.Distance BETWEEN 20 AND 21 THEN '20-21'
        WHEN inv.Distance BETWEEN 21 AND 22 THEN '21-22'
        WHEN inv.Distance BETWEEN 22 AND 23 THEN '22-23'
        WHEN inv.Distance BETWEEN 23 AND 24 THEN '23-24'
        WHEN inv.Distance BETWEEN 24 AND 25 THEN '24-25'
        WHEN inv.Distance BETWEEN 25 AND 26 THEN '25-26'
        WHEN inv.Distance BETWEEN 26 AND 27 THEN '26-27'
        WHEN inv.Distance BETWEEN 27 AND 28 THEN '27-28'
        WHEN inv.Distance BETWEEN 28 AND 29 THEN '28-29'
        WHEN inv.Distance BETWEEN 29 AND 30 THEN '29-30'
        WHEN inv.Distance BETWEEN 30 AND 31 THEN '30-31'
        WHEN inv.Distance BETWEEN 31 AND 32 THEN '31-32'
        WHEN inv.Distance BETWEEN 32 AND 33 THEN '32-33'
        WHEN inv.Distance BETWEEN 33 AND 34 THEN '33-34'
        WHEN inv.Distance BETWEEN 34 AND 35 THEN '34-35'
        WHEN inv.Distance >= 35 THEN '>=35'
        ELSE 'Unknown'
    END AS "Distance Buckets(KM)",
    COUNT(DISTINCT o.ID) AS Request,
    COUNT(DISTINCT ofr.ID) AS "Offered Requests",
    COUNT(DISTINCT allot.ID) AS "Accepted Requests",
    COUNT(DISTINCT CASE WHEN o.Status = 'Ride' THEN o.ID END) AS Ride,
    SUM(inv.Fare) AS "Total Ride Fare(GMV)(IRR)",
    CONCAT(ROUND(COUNT(DISTINCT ofr.ID) * 100.0 / COUNT(DISTINCT o.ID)), '%') AS "Offered-Order / Created-Order %",
    CONCAT(ROUND(COUNT(DISTINCT allot.ID) * 100.0 / COUNT(DISTINCT ofr.ID)), '%') AS "Accepted-Order / Offered-Order%",
    CONCAT(ROUND(COUNT(DISTINCT CASE WHEN o.Status = 'Ride' THEN o.ID END) * 100.0 / COUNT(DISTINCT o.ID)), '%') AS "Fullfillment Rate%",
    CONCAT('  ', ROUND(SUM(inv.Fare) / COUNT(DISTINCT CASE WHEN o.Status = 'Ride' THEN o.ID END)), ' ') AS "Average Ride Fare"
FROM
    `Order` o
LEFT JOIN
    `Offer` ofr ON o.ID = ofr.Order_ID
LEFT JOIN
    Allotment allot ON ofr.ID = allot.Order_ID
LEFT JOIN
    Invoice inv ON o.ID = inv.Order_ID
WHERE
    o.City = 'A'
    AND o.Service_Type = 1
    AND o.Created_date = '6/22/2022'
GROUP BY `Distance Buckets(KM)`
ORDER BY 
    CASE
        WHEN `Distance Buckets(KM)` LIKE '%>=%' THEN CAST(SUBSTRING_INDEX(`Distance Buckets(KM)`, '>=', -1) AS SIGNED)
        WHEN `Distance Buckets(KM)` LIKE '%-%' THEN CAST(SUBSTRING_INDEX(`Distance Buckets(KM)`, '-', -1) AS SIGNED)
        ELSE 0
    END;