--Однотабличные запросы
-- N.1
SELECT stud.name, stud.surname
FROM student stud
WHERE score > 4 and score < 4.5

-- N.2
SELECT stud.name::text, CAST(stud.surname AS varchar), stud.score::varchar
FROM student stud
WHERE score > 4 and score < 4.5

-- N.3
SELECT stud.uni_group, stud.name, stud.surname
FROM student stud
ORDER BY stud.uni_group, stud.name 

-- N.4
SELECT stud.name, stud.surname, stud.score
FROM student stud
WHERE stud.score > 4
ORDER BY stud.score desc

-- N.5
SELECT *
FROM hobby hobb
WHERE hobb.name='swiming' or hobb.name='surfing'

-- N.6
SELECT stho.n_z, stho.id_hobby
FROM stud_hobby stho
WHERE stho.date_start between '2011/02/25' and '2017/02/27' and stho.date_finish IS NULL

-- N.7
SELECT stud.name, stud.surname, stud.score
FROM student stud
WHERE stud.score > 4.5
ORDER BY stud.score desc

-- N.8
SELECT *
FROM student stud
WHERE stud.score > 4.5
ORDER BY stud.score desc
LIMIT 3

-- N.9
SELECT *,
 CASE 
 WHEN hobb.risk < 2 THEN 'Очень низкий'
 WHEN hobb.risk >= 2 and hobb.risk < 4 THEN 'Низкий' 
 WHEN hobb.risk >= 4 and hobb.risk < 6 THEN 'Средний' 
 WHEN hobb.risk >= 6 and hobb.risk < 8 THEN 'Высокий' 
 WHEN hobb.risk >= 8 THEN 'Очень высокий' 
 ELSE 'Мы точно никогда не выведем это сообщение'
END
FROM hobby hobb

-- N.10
SELECT *
FROM hobby hobb
ORDER BY hobb.risk desc
LIMIT 3

--Групповые функции
--N.1
SELECT uni_group,
       COUNT(uni_group) AS stud_count
FROM student
GROUP BY uni_group
ORDER BY uni_group DESC
--N.2
SELECT MAX(stud.score), stud.uni_group
FROM student stud
GROUP BY stud.uni_group
ORDER BY stud.uni_group DESC
--N.3
SELECT COUNT(DISTINCT stud.surname)
FROM student stud
--N.4
SELECT COUNT(EXTRACT(YEAR FROM stud.date_birth)), EXTRACT(YEAR FROM stud.date_birth)
FROM student stud
GROUP BY EXTRACT(YEAR FROM stud.date_birth)
--N.5
SELECT stud.uni_group, AVG(stud.score) AS REAL 
FROM student stud
GROUP BY stud.uni_group
--N.6
SELECT stud.uni_group, AVG(stud.score) AS REAL 
FROM student stud
GROUP BY stud.uni_group
ORDER BY  AVG(stud.score) desc
LIMIT 1
--N.7
SELECT stud.uni_group, AVG(stud.score) 
FROM student stud
GROUP BY stud.uni_group
HAVING AVG(stud.score) > 3.5
ORDER BY AVG(stud.score) desc;
--N.8
SELECT stud.uni_group, COUNT(stud.n_z),AVG(stud.score), MAX(stud.score), MIN(stud.score)
FROM student stud
GROUP BY stud.uni_group
--N.9
SELECT max_score, stud.name, stud.surname
FROM student stud,
	(SELECT MAX(stud.score) AS max_score
	FROM student stud
	GROUP BY stud.uni_group) t
WHERE stud.uni_group = '2254' and stud.score = max_score
--N.10
SELECT max_score, stud.uni_group, stud.name, stud.surname
FROM
	(SELECT MAX(stud.score) AS max_score, stud.uni_group
	FROM student stud
	GROUP BY stud.uni_group) t,
	student stud
WHERE max_score = stud.score
ORDER BY max_score desc


--Многотабличные запросы
-- N.1
SELECT stud.name, stud.surname, hobb.name
FROM student stud, hobby hobb, stud_hobby stho
WHERE stud.n_z = stho.n_z and id_hobby = hobb.id

-- N.2

