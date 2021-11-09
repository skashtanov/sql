SELECT DISTINCT amount
FROM book;


SELECT 
    author AS Автор
  , COUNT(amount) AS Различных_книг
  , SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY author;


SELECT 
    author 
  , MIN(price) AS Минимальная_цена
  , MAX(price) AS Максимальная_цена 
  , AVG(price) AS Средняя_цена
FROM book
GROUP BY author;


SELECT 
    author
  , ROUND(SUM(price * amount), 2) AS Стоимость
  , ROUND(SUM(price * amount) * 18 / 118, 2) AS НДС
  , ROUND(SUM(price * amount) * 100 / 118, 2) AS Стоимость_без_НДС
FROM book
GROUP BY author;


SELECT 
    MIN(price) AS Минимальная_цена
  , MAX(price) AS Максимальная_цена
  , ROUND(AVG(price), 2) AS Средняя_цена
FROM book;


SELECT
    ROUND(AVG(price), 2) AS Средняя_цена
  , ROUND(SUM(price * amount), 2) AS Стоимость
FROM book
WHERE (amount BETWEEN 5 AND 14);


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


SELECT 
    author 
  , ROUND(SUM(price * amount), 2) AS Total
FROM book
WHERE author != 'Eсенин С.А.'
GROUP BY author
HAVING 
    SUM(price * amount) > 1000
ORDER BY
    SUM(price * amount)
    DESC;
