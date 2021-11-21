--
SELECT 
    name_student
  , date_attempt
  , result
FROM 
    [subject]
    INNER JOIN attempt USING(subject_id)
    INNER JOIN student USING(student_id)
WHERE name_subject = 'Основы баз данных'
ORDER BY result DESC;


--
SELECT 
    name_subject
  , COUNT(attempt_id) AS Количество 
  , ROUND(SUM(result) / COUNT(attempt_id), 2) AS Среднее
FROM 
    [subject] 
    LEFT JOIN attempt USING(subject_id)
GROUP BY name_subject
ORDER BY Среднее DESC;


--
SELECT 
    name_student
  , result
FROM 
    student 
    INNER JOIN attempt USING(student_id)
WHERE 
    result = (
        SELECT MAX(result) AS Best
        FROM attempt
        GROUP BY student_id
        ORDER BY Best DESC
        LIMIT 1
    )
ORDER BY name_student;


--
SELECT 
    name_student
  , name_subject
  , DATEDIFF(
        MAX(date_attempt), MIN(date_attempt)
    ) AS Интервал
FROM 
    [subject]
    INNER JOIN attempt USING(subject_id)
    INNER JOIN student USING(student_id)
GROUP BY 
    name_student
  , name_subject
HAVING COUNT(attempt_id) > 1
ORDER BY Интервал;


--
SELECT 
    name_subject
  , COUNT(DISTINCT student_id) AS Количество
FROM 
    [subject]
    LEFT JOIN attempt USING(subject_id)
GROUP BY name_subject
ORDER BY 
    Количество DESC
  , name_subject;


--
SELECT 
    question_id
  , name_question
FROM
    [subject]
    INNER JOIN question USING(subject_id)
WHERE subject_id = (
    SELECT subject_id 
    FROM [subject] 
    WHERE name_subject = 'Основы баз данных'
)
ORDER BY RAND()
LIMIT 3;


--
SELECT 
    name_question
  , name_answer
  , IF(is_correct, 'Верно', 'Неверно') AS Результат
FROM 
    question
    INNER JOIN testing USING(question_id)
    INNER JOIN answer USING(answer_id)
WHERE attempt_id = 7;


--
SELECT 
    name_student
  , name_subject
  , date_attempt
  , ROUND(SUM(is_correct) / 3 * 100, 2) AS Результат
FROM 
    answer 
    INNER JOIN testing USING(answer_id)
    INNER JOIN attempt USING(attempt_id)
    INNER JOIN student USING(student_id)
    INNER JOIN subject USING(subject_id)
GROUP BY 
    name_student
  , name_subject
  , date_attempt
ORDER BY 
    name_student
  , date_attempt DESC;


--
SELECT 
    name_subject
  , CONCAT(LEFT(name_question, 30), '...') AS Вопрос
  , COUNT(answer_id) AS Всего_ответов
  , ROUND(SUM(is_correct) / COUNT(answer_id) * 100, 2) AS Успешность
FROM 
    [subject]
    INNER JOIN question  USING(subject_id)
    INNER JOIN testing  USING(question_id)
    INNER JOIN answer  USING(answer_id)
GROUP BY 
    name_subject
  , name_question
ORDER BY
    name_subject
  , Успешность DESC
  , name_question;


--
SELECT 
    name_subject
  , name_question
  , name_answer
FROM 
    [subject]
    INNER JOIN question USING(subject_id)
    INNER JOIN answer USING(question_id)
WHERE is_correct = TRUE
ORDER BY name_subject;
