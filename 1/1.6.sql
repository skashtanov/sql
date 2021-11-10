--
SELECT 
    [name]
  , city
  , per_diem
  , date_first
  , date_last
FROM trip
WHERE name LIKE '%_а _%'
ORDER BY date_last DESC;


--
SELECT DISTINCT name 
FROM trip
WHERE city = 'Москва'
ORDER BY name;


--
SELECT
    city
  , COUNT(city) AS Количество
FROM trip
GROUP BY city
ORDER BY city;



