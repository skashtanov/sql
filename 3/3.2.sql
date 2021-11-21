--
INSERT INTO attempt (student_id, subject_id, date_attempt)
VALUES (
    (SELECT student_id FROM student WHERE name_student = 'Баранов Павел'),
    (SELECT subject_id FROM subject WHERE name_subject = 'Основы баз данных'),
    NOW()
);

SELECT *
FROM attempt;


--
INSERT INTO testing(attempt_id, question_id)
SELECT 
    attempt_id
  , question_id
FROM 
    question
    INNER JOIN attempt USING(subject_id)
WHERE attempt_id = (SELECT MAX(attempt_id) FROM attempt)
ORDER BY RAND(question_id)
LIMIT 3;

SELECT *
FROM testing;


--
UPDATE attempt
SET result = (
    SELECT ROUND(SUM(is_correct) * 100 / 3, 0) 
    FROM 
        answer
        INNER JOIN testing USING(answer_id)
    WHERE attempt_id = 8
)
WHERE attempt_id = 8;


SELECT * 
FROM attempt;


--
DELETE FROM attempt
WHERE date_attempt < '2020-05-01';

SELECT *
FROM attempt;

SELECT *
FROM testing;


--
SELECT 
    name_student
  , attempt_id
  , ROUND(SUM(is_correct) / COUNT(is_correct) * 100, 0) AS result
FROM 
    answer
    INNER JOIN question USING(question_id)
    INNER JOIN subject USING(subject_id)
    INNER JOIN attempt USING(subject_id)
    INNER JOIN student USING(student_id)
WHERE subject_id = (
    SELECT subject_id
    FROM [subject]
    WHERE name_subject = 'Основы баз данных'
)
GROUP BY 
    name_student
  , attempt_id;
