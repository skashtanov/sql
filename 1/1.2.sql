--
SELECT *
FROM book;


SELECT
    author
  , title
  , price
FROM book;


--
SELECT 
    title AS Название
  , author AS Автор
FROM book;


--
SELECT 
    title
  , amount
  , amount * 1.65 AS pack
FROM book;


--
SELECT 
    title
  , author
  , amount
  , ROUND(price * 0.7, 2) AS new_price
FROM book;


--
SELECT author, title, 
    ROUND(
        IF(author = 'Булгаков М.А.', 
           price*1.1,
           IF (author = 'Есенин С.А.', price*1.05, price)            
        ), 
        2
    ) AS new_price
FROM book;


--
SELECT 
    author
  , title
  , price
FROM book
WHERE amount < 10;
        

--
SELECT 
    title
  , author
  , price
  , amount
FROM book
WHERE (price < 500 OR price > 600)
      AND 
      (price * amount >= 5000); 


--
SELECT 
    title
  , author
FROM book
WHERE (price BETWEEN 540.50 AND 800) 
      AND 
      amount IN (2, 3, 5, 7);


--
SELECT 
    author
  , title
FROM book
WHERE (amount BETWEEN 2 AND 14)
ORDER BY author DESC, title;


--
SELECT 
    title
  , author
FROM book
WHERE (title LIKE '%_ %_')
      AND 
      (author LIKE '%С.%')
ORDER BY title;


--
SELECT 
    title
  , price
  , amount
FROM book
WHERE author IN ('Булгаков М.А.', 'Достоевский Ф.М.')
      AND 
      (price BETWEEN 400 AND 600)
ORDER BY amount DESC;
