--
SELECT 
    title
  , name_genre
  , price
FROM
    book 
    INNER JOIN genre ON (
        book.genre_id = genre.genre_id
        AND
        book.amount > 8
    )
ORDER BY book.price DESC;


--
SELECT DISTINCT name_genre
FROM 
    book 
    LEFT JOIN genre ON (
        genre.genre_id NOT IN (
            SELECT genre_id
            FROM book
        )
    );


--
SELECT 
    name_city
  , name_author
  , DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY) AS Дата
FROM city CROSS JOIN author
ORDER BY name_city
       , Дата DESC;


--
SELECT 
    name_genre
  , title
  , name_author
FROM 
    genre 
    INNER JOIN book ON genre.genre_id = book.genre_id
    INNER JOIN author ON book.author_id = author.author_id
WHERE 
    name_genre LIKE '%роман%' 
    OR 
    name_genre LIKE '%Роман%'
ORDER BY title;


--
SELECT 
    author.name_author
  , SUM(book.amount) AS Количество
FROM
    author 
    LEFT JOIN book ON author.author_id = book.author_id
GROUP BY name_author
HAVING (
    Количество < 10
    OR
    Количество IS NULL
)
ORDER BY Количество;


--
SELECT name_author 
FROM author
WHERE author_id IN (
    SELECT author_id
    FROM book
    GROUP BY author_id
    HAVING COUNT(DISTINCT genre_id) = 1
)
ORDER BY name_author;


--
SELECT 
    title
  , name_author
  , name_genre
  , price, amount
FROM 
    (
        (
            author 
            INNER JOIN book ON author.author_id = book.author_id
        ) 
        INNER JOIN genre ON book.genre_id = genre.genre_id
    )
WHERE 
    genre.genre_id IN (
        SELECT query_in1.genre_id
        FROM (
            (
                /* Считаем сколько книг каждого жанра */
                SELECT 
                    genre_id
                  , SUM(amount) AS total_amount
                FROM book
                GROUP BY genre_id
                ORDER BY total_amount DESC
            ) AS query_in1
            INNER JOIN (
                /* Находим количество книг самого популярного жанра */
                SELECT 
                    genre_id
                  , SUM(amount) AS total_amount
                FROM book
                GROUP BY genre_id
                ORDER BY total_amount DESC
                LIMIT 1
            ) AS query_in2
            ON query_in1.total_amount = query_in2.total_amount
        )
    )
ORDER BY title;


--
SELECT 
    book.title AS Название
  , (
        SELECT name_author 
        FROM author
        WHERE author_id = book.author_id
    ) AS Автор
  , book.amount + supply.amount AS Количество
FROM 
    supply 
    INNER JOIN book ON ( 
        supply.title = book.title
        AND
        supply.author = (
            SELECT name_author
            FROM author
            WHERE author_id = book.author_id
        )
        AND supply.price = book.price
    );


--
SELECT 
    name_author AS [Name]
  , COUNT(DISTINCT title) as Books
FROM 
    book 
    INNER JOIN author USING(author_id)
WHERE amount > (SELECT AVG(amount) FROM book)
GROUP BY author_id
ORDER BY [Name];
 







            

