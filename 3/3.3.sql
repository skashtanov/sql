--
SELECT DISTINCT name_enrollee
FROM
    enrollee
    INNER JOIN program_enrollee USING(enrollee_id)
    INNER JOIN program USING(program_id)
WHERE 
    program_id = (
        SELECT program_id
        FROM program
        WHERE name_program = 'Мехатроника и робототехника'
    )
ORDER BY name_enrollee;


--
SELECT DISTINCT name_program
FROM 
    [subject]
    INNER JOIN program_subject USING(subject_id)
    INNER JOIN program USING(program_id)
WHERE name_subject = 'Информатика'
ORDER BY name_program DESC;


--
SELECT
    name_subject
  , COUNT(*) AS Количество
  , MAX(result) AS Максимум
  , MIN(result) AS Минимум
  , ROUND(AVG(result), 1) AS Среднее
FROM 
    [subject]
    INNER JOIN enrollee_subject USING(subject_id)
GROUP BY name_subject
ORDER BY name_subject;


--
SELECT name_program
FROM 
    program
    INNER JOIN program_subject USING(program_id)
GROUP BY name_program
HAVING MIN(min_result) >= 40
ORDER BY name_program;


--
SELECT 
    name_program
  , (SELECT MAX(plan) FROM program) as plan
FROM program
WHERE plan = (SELECT MAX(plan) FROM program);


--
SELECT
    name_enrollee
  , IF(SUM(bonus) IS NULL, 0, SUM(bonus)) AS Бонус
FROM
    enrollee
    LEFT JOIN enrollee_achievement USING(enrollee_id)
    LEFT JOIN achievement USING(achievement_id)
GROUP BY name_enrollee
ORDER BY name_enrollee;


--
SELECT 
    name_department
  , name_program
  , plan
  , COUNT(*) AS Количество
  , ROUND(COUNT(*) / plan, 2) AS Конкурс
FROM 
    department
    INNER JOIN program USING(department_id)
    INNER JOIN program_enrollee USING(program_id)
GROUP BY 
    name_department
  , name_program
  , plan
ORDER BY Конкурс DESC;


--
SELECT name_program
FROM 
    program
    INNER JOIN program_subject USING(program_id)
    INNER JOIN subject USING(subject_id)
WHERE name_subject IN ('Информатика', 'Математика')
GROUP BY name_program
HAVING COUNT(*) = 2
ORDER BY name_program;


--
SELECT 
    name_program
  , name_enrollee
  , SUM(result) AS itog
FROM
    enrollee 
    INNER JOIN program_enrollee USING(enrollee_id)
    INNER JOIN program USING(program_id)
    INNER JOIN program_subject USING(program_id)
    INNER JOIN subject USING(subject_id)
    INNER JOIN enrollee_subject ON (
        [subject].subject_id = enrollee_subject.subject_id 
        AND
        enrollee_subject.enrollee_id = enrollee.enrollee_id
    )
GROUP BY
    name_program
  , name_enrollee
ORDER BY
    name_program
  , itog DESC;


--
SELECT 
    name_program
  , name_enrollee
  , SUM(result) - SUM(min_result) AS Extra
FROM
    enrollee 
    INNER JOIN program_enrollee USING(enrollee_id)
    INNER JOIN program USING(program_id)
    INNER JOIN program_subject USING(program_id)
    INNER JOIN subject USING(subject_id)
    INNER JOIN enrollee_subject ON (
        [subject].subject_id = enrollee_subject.subject_id 
        AND
        enrollee_subject.enrollee_id = enrollee.enrollee_id
    )
GROUP BY
    name_program
  , name_enrollee
ORDER BY
    name_program
  , name_enrollee;


