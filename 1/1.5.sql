--
CREATE TABLE supply(
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title     VARCHAR(50),
    author    VARCHAR(30),
    price     DECIMAL(8, 2),
    amount    INT    
);


--
INSERT INTO supply
    (title, author, price, amount)
VALUES 
    ('Лирика', 'Пастернак Б.Л.', 518.99, 2), 
    ('Черный человек', 'Есенин С.А.', 570.20, 6),
    ('Белая гвардия', 'Булгаков М.А.', 540.50, 7),
    ('Идиот', 'Достоевский Ф.М.', 360.80, 3);


--
INSERT INTO book (title, author, price, amount) 
SELECT 
    title, 
   , author 
   , price
   , amount
FROM supply
WHERE author NOT IN ('Булгаков М.А.', 'Достоевский Ф.М.');

SELECT *
FROM book;

--
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN (
    SELECT author
    FROM book
);

SELECT *
FROM book;


--
UPDATE book
SET price = price * 0.9
WHERE amount BETWEEN 5 AND 10;

SELECT *
FROM book;


--
UPDATE book
SET 
    price = IF(buy = 0, price * 0.9, price),
    buy = IF(buy > amount, amount, buy);
    

SELECT *
FROM book;


--
UPDATE book, supply
SET 
    book.amount = book.amount + supply.amount,
    book.price  = (book.price + supply.price) / 2
WHERE 
    book.title = supply.title 
    AND
    book.author = supply.author;
    

SELECT *
FROM book;


--
DELETE FROM supply
WHERE 
    author IN (
        SELECT author
        FROM book
        GROUP BY author
        HAVING SUM(amount) > 10
    );
               
SELECT *
FROM supply;


--
CREATE TABLE ordering AS
SELECT 
    author 
   , title
   , (SELECT ROUND(AVG(amount)) FROM book) AS amount
FROM book
WHERE amount < (SELECT AVG(amount) FROM book);

SELECT *
FROM ordering;


--
UPDATE supply, book
SET
    book.price    = book.price * 1.1
  , book.amount   = book.amount + supply.amount
  , supply.amount = 0
WHERE
    book.title = supply.title
    AND
    book.author = supply.author;

DELETE FROM supply
WHERE amount = 0;

SELECT *
FROM supply;