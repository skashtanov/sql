--
CREATE TABLE fine(
    fine_id        INT PRIMARY KEY AUTO_INCREMENT,
    [name]           VARCHAR(30),
    number_plate   VARCHAR(6),
    violation      VARCHAR(50),
    sum_fine       DECIMAL(8, 2),
    date_violation DATE,
    date_payment   DATE
);


--
INSERT INTO fine (
    [name]
  , number_plate
  , violation
  , sum_fine
  , date_violation
  , date_payment
)
VALUES ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', null, '2020-02-14', null),
       ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', null, '2020-02-23', null),
       ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', null, '2020-03-03', null);


--
UPDATE fine, traffic_violation AS tv
SET fine.sum_fine = tv.sum_fine
WHERE 
    (fine.sum_fine IS NULL)
    AND
    (tv.violation = fine.violation);


--
SELECT 
    [name]
  , number_plate
  , violation
FROM fine
GROUP BY  
    [name]
  , number_plate
  , violation
HAVING COUNT(*) > 1
ORDER BY 
    [name]
  , number_plate
  , violation;


--
UPDATE 
    fine, 
  , (
        SELECT 
            [name]
          , number_plate
          , violation
        FROM fine
        GROUP BY 
            [name]
          , number_plate
          , violation
        HAVING COUNT(*) > 1
        ORDER BY 
            [name]
          , number_plate
          , violation
    ) query_in
SET sum_fine = sum_fine * 2
WHERE
    (fine.name = query_in.name)
    AND
    (fine.number_plate = query_in.number_plate)
    AND
    (fine.date_payment IS NULL);

SELECT 
    [name]
  , number_plate
  , violation
  , sum_fine
  , date_violation
  , date_payment
FROM fine;


--
UPDATE 
    fine
  , payment AS pay
SET
    fine.date_payment = pay.date_payment
  , fine.sum_fine = IF(
        DATEDIFF(pay.date_payment, fine.date_violation) <= 20
      , fine.sum_fine * 0.5
      , fine.sum_fine
    )
WHERE
    fine.name = pay.name
    AND
    fine.number_plate = pay.number_plate
    AND
    fine.violation = pay.violation
    AND
    fine.date_violation = pay.date_violation;
  
  
SELECT 
    [name]
  , number_plate
  , violation
  , sum_fine
  , date_violation
  , date_payment
FROM fine;  


--
CREATE TABLE back_payment AS
SELECT 
    [name]
  , number_plate
  , violation
  , sum_fine
  , date_violation
FROM fine
WHERE fine.date_payment IS NULL;

SELECT *
FROM back_payment;


--
DELETE FROM fine
WHERE DATEDIFF('2020-02-01', date_violation) > 0; 

SELECT  
    [name]
  , number_plate
  , violation
  , sum_fine
  , date_violation
  , date_payment
FROM fine;








    









