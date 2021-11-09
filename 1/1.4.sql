SELECT 
    author 
  , title, 
  , price
FROM book
WHERE price <= (SELECT AVG(price) FROM book)
ORDER BY price DESC;


SELECT 
    author 
  , title 
  , price
FROM book
WHERE price - (SELECT MIN(price) FROM book) BETWEEN 0 AND 150
ORDER BY price;


SELECT 
    author 
  , title 
  , amount
FROM book
WHERE amount IN (
        SELECT amount 
        FROM book
        GROUP BY amount
        HAVING COUNT(amount) = 1
    );



SELECT 
    author
  , title
  , price
FROM book
WHERE 
    price < ANY (
        SELECT MIN(price)
        FROM book
        GROUP BY author
    );


SELECT 
    title
  , author
  , amount
  , (SELECT MAX(amount) FROM book) - amount AS Заказ
FROM book
WHERE (SELECT MAX(amount) FROM book) - amount != 0;


SELECT 
    title
  , author
  , amount - (
        SELECT MIN(amount)
        FROM book
        WHERE amount <> 0
    ) AS Plan
FROM book
WHERE amount - (
        SELECT MIN(amount)
        FROM book
        WHERE amount != 0
    ) != 0
ORDER BY Plan DESC;
