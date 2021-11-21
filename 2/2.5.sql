--
INSERT INTO client(name_client, city_id, email)
VALUES(
    'Попов Илья',
    (SELECT city_id FROM city WHERE name_city = 'Москва'), 
    'popov@test'
);
       
SELECT *
FROM client;


--
INSERT INTO buy(buy_description, client_id)
SELECT 
    'Связаться со мной по вопросу доставки'
  , client_id
FROM client
WHERE name_client = 'Попов Илья';

SELECT *
FROM buy;


--
INSERT INTO buy_book(buy_id, book_id, amount)
SELECT 
    5
  , book_id
  , 2
FROM 
    author
    INNER JOIN book USING(author_id)
WHERE 
    name_author LIKE '%Пастернак%'
    AND
    title = 'Лирика';

INSERT INTO buy_book(buy_id, book_id, amount)
SELECT 
    5
  , book_id
  , 1
FROM 
    author
    INNER JOIN book USING(author_id)
WHERE 
    name_author LIKE '%Булгаков%'
    AND
    title = 'Белая гвардия';
    
SELECT *
FROM buy_book;


--
UPDATE 
    book
    INNER JOIN buy_book USING(book_id)
SET book.amount = book.amount - buy_book.amount
WHERE buy_book.buy_id = 5;

SELECT *
FROM book;


--
CREATE TABLE buy_pay AS
SELECT 
    title
  , name_author
  , price
  , buy_book.amount
  , buy_book.amount * price AS Стоимость
FROM
    author
    INNER JOIN book USING(author_id)
    INNER JOIN buy_book USING(book_id)
WHERE buy_id = 5
ORDER BY title;
    
SELECT *
FROM buy_pay;


--
CREATE TABLE buy_pay AS
SELECT 
    buy_id
  , SUM(buy_book.amount) AS Количество,
  , SUM(buy_book.amount * book.price) AS Итого
FROM 
  book
  INNER JOIN buy_book USING(book_id)
WHERE buy_id = 5
GROUP BY buy_book.buy_id;
  
  
SELECT *
FROM buy_pay;


--
INSERT INTO buy_step(buy_id, step_id, date_step_beg, date_step_end)
SELECT 
    buy_id
  , step_id
  , NULL AS date_step_beg
  , NULL AS date_step_end
FROM 
    buy
    CROSS JOIN step ON buy.buy_id = 5;
    
SELECT *
FROM buy_step;


--
UPDATE 
    buy_step
  , step
SET date_step_beg = '2020-04-12'
WHERE 
    buy_id = 5
    AND
    buy_step.step_id = (SELECT step_id FROM step WHERE name_step = 'Оплата');

SELECT *
FROM buy_step;


--
UPDATE buy_step
SET date_step_end = '2020-04-13'
WHERE 
    buy_id = 5
    AND
    step_id = (SELECT step_id FROM step WHERE name_step = 'Оплата');


UPDATE buy_step
SET date_step_beg = '2020-04-13'
WHERE 
    buy_id = 5
    AND
    step_id = (SELECT step_id FROM step WHERE name_step = 'Упаковка');
    
    
SELECT *
FROM buy_step;


--
SELECT name_city
FROM (
    SELECT 
        name_city
      , SUM(amount) AS Amount
    FROM 
        city
        INNER JOIN client USING(city_id)
        INNER JOIN buy USING(client_id)
        INNER JOIN buy_book USING(buy_id)
        INNER JOIN buy_step USING(buy_id)
        INNER JOIN step USING(step_id)
    WHERE
        date_step_beg IS NOT NULL
        AND
        date_step_end IS NOT NULL
        AND
        step_id = (SELECT step_id FROM step WHERE name_step = 'Оплата')
    GROUP BY name_city
    ORDER BY Amount DESC
) AS query_in
LIMIT 3;
