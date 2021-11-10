--
SELECT DISTINCT amount
FROM book;


--
SELECT 
    author AS Автор
  , COUNT(amount) AS Различных_книг
  , SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY author;


--
SELECT 
    author 
  , MIN(price) AS Минимальная_цена
  , MAX(price) AS Максимальная_цена 
  , AVG(price) AS Средняя_цена
FROM book
GROUP BY author;


--
SELECT 
    author
  , ROUND(SUM(price * amount), 2) AS Стоимость
  , ROUND(SUM(price * amount) * 18 / 118, 2) AS НДС
  , ROUND(SUM(price * amount) * 100 / 118, 2) AS Стоимость_без_НДС
FROM book
GROUP BY author;


--
SELECT 
    MIN(price) AS Минимальная_цена
  , MAX(price) AS Максимальная_цена
  , ROUND(AVG(price), 2) AS Средняя_цена
FROM book;


--
SELECT
    ROUND(AVG(price), 2) AS Средняя_цена
  , ROUND(SUM(price * amount), 2) AS Стоимость
FROM book
WHERE (amount BETWEEN 5 AND 14);


--
SELECT 
    author
  , SUM(price * amount) AS Стоимость
FROM book
WHERE (title != 'Идиот')
      AND 
      (title != 'Белая гвардия')
GROUP BY author
HAVING SUM(price * amount) > 5000
ORDER BY SUM(price * amount) DESC;


--
SELECT 
    author 
  , ROUND(SUM(price * amount), 2) AS Total
FROM book
WHERE author != 'Eсенин С.А.'
GROUP BY author
HAVING SUM(price * amount) > 1000
ORDER BY SUM(price * amount) DESC;


--
SELECT
    city
  , COUNT(city) AS Количество
FROM trip
GROUP BY city
ORDER BY city;


--
SELECT 
    city
  , COUNT(city) AS Количество
FROM trip
GROUP BY city
ORDER BY COUNT(city) DESC
LIMIT 2;


--
SELECT 
    [name]
  , city
  , DATEDIFF(date_last, date_first) + 1 as Длительность
FROM trip
WHERE city NOT IN ('Москва', 'Санкт-Петербург')
ORDER BY Длительность DESC,
       , city DESC;


--
SELECT 
    [name]
  , city
  , date_first
  , date_last
FROM trip
WHERE DATEDIFF(date_last, date_first) = (
        SELECT MIN(DATEDIFF(date_last, date_first))
        FROM trip
      );


--
SELECT 
    [name]
  , city
  , date_first
  , date_last
FROM trip
WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city
       , [name];


--
SELECT 
    MONTHNAME(date_first) AS Месяц
  , COUNT(MONTHNAME(date_first)) AS Количество
FROM trip
GROUP BY Месяц
ORDER BY Количество DESC
       , Месяц;


--
SELECT 
    [name]
  , city
  , date_first
  , ((DATEDIFF(date_last, date_first) + 1) * per_diem) AS Сумма
FROM trip
WHERE 
    MONTHNAME(date_first) IN ('February', 'March')
    AND
    YEAR(date_first) = 2020
ORDER BY 
    [name]
  , Сумма DESC;


--
SELECT 
    [name]
  , SUM(
      (DATEDIFF(date_last, date_first) + 1) * per_diem
    ) AS Сумма
FROM trip
GROUP BY [name]
HAVING COUNT([name]) > 3
ORDER BY Сумма DESC;

