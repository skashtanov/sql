--
SELECT 
    buy.buy_id
  , book.title
  , book.price
  , buy_book.amount
FROM
    client 
    INNER JOIN buy USING(client_id)
    INNER JOIN buy_book USING(buy_id)
    INNER JOIN book USING(book_id)
WHERE 
    client.name_client = 'Баранов Павел'
ORDER BY 
    buy.buy_id,
    book.title;


--
SELECT
    name_author
  , title
  , COUNT(buy_book.book_id) AS Количество
FROM     
    author 
    LEFT JOIN book USING(author_id)
    LEFT JOIN buy_book USING(book_id)
WHERE book.title IS NOT NULL
GROUP BY 
    name_author
  , title
ORDER BY 
    name_author
  , title;


--
SELECT 
    name_city
  , COUNT(*) AS Количество
FROM
    city 
    INNER JOIN client USING(city_id)
    INNER JOIN buy USING(client_id)
GROUP BY name_city
ORDER BY 
    Количество DESC
  , name_city;


--
SELECT 
    buy_id
  , date_step_end
FROM 
    step 
    INNER JOIN buy_step USING(step_id)
WHERE 
    step_id = 1
    AND
    date_step_end IS NOT NULL;


--
SELECT 
    buy_id
  , name_client
  , SUM(book.price * buy_book.amount) AS Стоимость
FROM
    client 
    INNER JOIN buy USING(client_id)
    INNER JOIN buy_book USING(buy_id)
    INNER JOIN book USING(book_id)
GROUP BY buy_id
ORDER BY buy_id;


--
SELECT 
    buy_id
  , name_step
FROM 
    buy_step 
    INNER JOIN step USING(step_id)
WHERE
    buy_step.date_step_beg IS NOT NULL
    AND
    buy_step.date_step_end IS NULL
ORDER BY buy_id;


--
SELECT 
    buy_id 
  , DATEDIFF(date_step_end, date_step_beg) AS Количество_дней
  , IF(
        DATEDIFF(date_step_end, date_step_beg) > days_delivery
      , DATEDIFF(date_step_end, date_step_beg) - days_delivery
      , 0
    ) AS Опоздание
FROM 
    city 
    INNER JOIN client USING(city_id)
    INNER JOIN buy USING(client_id)
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)
WHERE 
    step_id = (SELECT step_id FROM step WHERE name_step = 'Транспортировка')
    AND 
    date_step_beg IS NOT NULL
    AND 
    date_step_end IS NOT NULL
ORDER BY buy_id;


--
SELECT DISTINCT name_client
FROM 
    author
    INNER JOIN book USING(author_id)
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id)
    INNER JOIN client USING(client_id)
WHERE name_author LIKE '%Достоевский%'
ORDER BY name_client;


--
SELECT 
    name_genre
  , SUM(buy_book.amount) AS Количество
FROM
    genre 
    INNER JOIN book USING(genre_id)
    INNER JOIN buy_book USING(book_id)
GROUP BY genre_id
HAVING Количество = (
    SELECT MAX(total) FROM (
        SELECT SUM(buy_book.amount) AS total
        FROM
            genre 
            INNER JOIN book USING(genre_id)
            INNER JOIN buy_book USING(book_id)
        GROUP BY genre_id
        ) AS wrapped
    );


--
SELECT 
    YEAR(date_payment) AS Год
  , MONTHNAME(date_payment) AS Месяц
  , ROUND(SUM(price * amount), 2) AS Сумма
FROM buy_archive
GROUP BY 
    Год
  , Месяц
UNION ALL
SELECT 
    YEAR(date_step_end) AS Год
  , MONTHNAME(date_step_end) AS Месяц
  , ROUND(SUM(book.price * buy_book.amount), 2) AS Сумма
FROM 
    book
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id)
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)
WHERE 
    date_step_beg IS NOT NULL
    AND 
    date_step_end IS NOT NULL
    AND
    step_id = (SELECT step_id FROM step WHERE name_step = 'Оплата')
GROUP BY 
    Год
  , Месяц
ORDER BY 
    Месяц
  , Год;


--
SELECT 
    title
  , SUM(wrapped.Amount) AS Количество
  , SUM(wrapped.Total) AS Сумма
FROM (   
    SELECT 
        title
      , SUM(buy_archive.amount) AS Amount
      , SUM(buy_archive.amount * buy_archive.price) AS Total
    FROM 
        buy_archive
        INNER JOIN book USING(book_id)
    GROUP BY title
    UNION
    SELECT
        title
      , SUM(buy_book.amount) AS Amount
      , SUM(buy_book.amount * book.price) AS Total
    FROM
        book
        INNER JOIN buy_book USING(book_id)
        INNER JOIN buy USING(buy_id)
        INNER JOIN buy_step USING(buy_id)
        INNER JOIN step USING(step_id)
    WHERE
        date_step_beg IS NOT NULL
        AND 
        date_step_end IS NOT NULL
        AND
        step_id = (SELECT step_id FROM step WHERE name_step = 'Оплата')
    GROUP BY title
) AS wrapped
GROUP BY title
ORDER BY Сумма DESC;


--
SELECT 
    name_client as [Name]
  , ROUND(
        SUM(buy_book.amount * 0.75) + SUM(book.price * 0.25),
        2
    ) AS Weight
FROM 
    book
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id)
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)
    INNER JOIN client USING(client_id)
WHERE
    date_step_beg IS NOT NULL
    AND
    date_step_end IS NOT NULL
    AND
    step_id = (SELECT step_id FROM step WHERE name_step = 'Оплата')
GROUP BY [Name]
ORDER BY [Weight] DESC
LIMIT 1;





