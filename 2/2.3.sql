--
UPDATE
    book 
    INNER JOIN author USING(author_id)
    INNER JOIN supply ON (
        book.title = supply.title 
        AND 
        author.name_author = supply.author
        AND book.price != supply.price
    )
SET 
    book.amount = book.amount + supply.amount
  , book.price = (book.amount * book.price + supply.amount * supply.price) / (book.amount + supply.amount)
  , supply.amount = 0;


--
INSERT INTO author(name_author)
SELECT author
FROM 
    supply 
    LEFT JOIN author ON supply.author = author.name_author
WHERE name_author IS NULL;


--
INSERT INTO book (title, author_id, price, amount)
SELECT 
    title
  , author_id
  , price
  , amount
FROM 
    author 
    INNER JOIN supply ON author.name_author = supply.author
WHERE amount != 0;

SELECT *
FROM book;


--
UPDATE book
SET genre_id = (
    SELECT genre_id
    FROM genre
    WHERE name_genre = 'Поэзия'
)
WHERE 
    title = 'Стихотворения и поэмы'
    AND
    author_id = (
        SELECT author_id
        FROM author
        WHERE name_author = 'Лермонтов М.Ю.'
    );
    
UPDATE book
SET genre_id = (
    SELECT genre_id
    FROM genre
    WHERE name_genre = 'Приключения'
)
WHERE 
    title = 'Остров сокровищ'
    AND
    author_id = (
        SELECT author_id
        FROM author
        WHERE name_author = 'Стивенсон Р.Л.'
    );


--
DELETE FROM author
WHERE author_id IN (
    SELECT author_id
    FROM book
    GROUP BY author_id
    HAVING SUM(amount) < 20
);

SELECT * 
FROM author;

SELECT *
FROM book;


--
DELETE FROM genre
WHERE genre_id IN (
    SELECT genre_id
    FROM book
    GROUP BY genre_id
    HAVING COUNT(*) < 4
);

SELECT *
FROM genre;

SELECT *
FROM book;


--
DELETE FROM author
USING
    author 
    INNER JOIN book USING(author_id)
WHERE
    genre_id = (SELECT genre_id FROM genre WHERE name_genre = 'Поэзия');
    
SELECT *
FROM author;

SELECT *
FROM book;


--
INSERT INTO book (title, author_id, genre_id, price, amount)
SELECT 
    supply.title
  , (
        SELECT author_id 
        FROM author
        WHERE name_author = supply.author
    ) as author_id
  , NULL AS genre_id
  , supply.price
  , supply.amount
FROM 
    supply 
    LEFT JOIN book ON supply.title = book.title
    WHERE book.title IS NULL;
