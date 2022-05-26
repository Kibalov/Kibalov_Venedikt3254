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
SELECT stud.name, stud.surname, stud.n_z
FROM student stud,
	(SELECT stho.n_z as n_z2
	FROM stud_hobby stho
	WHERE ABS(stho.date_start - stho.date_finish) = (
		SELECT MAX(t.datediff)
		FROM 
			(SELECT ABS(stho.date_start - stho.date_finish) as datediff, stho.n_z as n_z1
			FROM stud_hobby stho) t)) t1
WHERE stud.n_z = t1.n_z2

-- N.3
SELECT stud.name, stud.surname, stud.n_z, stud.date_birth, t1.ho_ri
FROM student stud,
	(SELECT AVG(stud.score) as avg_sc
	FROM student stud) t,
	(SELECT stho.n_z as n_z1, SUM(hobb.risk) as ho_ri
	FROM hobby hobb, stud_hobby stho
	WHERE stho.id_hobby = hobb.id
	GROUP BY stho.n_z)t1
WHERE stud.score > t.avg_sc and t1.n_z1 = stud.n_z and t1.ho_ri > 0

-- N.4
SELECT stud.name, stud.surname, stud.n_z, t.months
FROM student stud,
	(SELECT stho.n_z as n_z1, (date_finish - date_start )/30 as months
	FROM stud_hobby stho
	WHERE date_finish IS NOT NULL
	GROUP BY n_z1, months) t
WHERE stud.n_z = t.n_z1

-- N.5
SELECT stud.name, stud.surname, stud.n_z, stud.date_birth
FROM student stud,
	(SELECT extract(year from age(CURRENT_DATE, date_birth)) as age, n_z as n_z1
	FROM student) t
WHERE t.n_z1 = stud.n_z and t.age >18

-- N.6
SELECT t.t_ungr, AVG(t.t_sc)
FROM student stud, 
	(SELECT stud.uni_group as t_ungr, stud.score as t_sc
	FROM student stud, stud_hobby stho
	WHERE stho.n_z = stud.n_z) t 
GROUP BY t.t_ungr

-- N.7
SELECT t1.dt_st_fi, hobby.name, hobby.risk, stud.n_z
FROM student stud, hobby, 
	(SELECT stho.n_z as n_z1, 12 * extract(year from age(stho.date_finish, stho.date_start))+ extract(month from age(stho.date_finish, stho.date_start)) as dt_st_fi, stho.id_hobby as t1_id_ho
	FROM stud_hobby stho,
		(SELECT MAX(12 * extract(year from age(date_finish, date_start))+ extract(month from age(date_finish, date_start))) as t_date_diff
		FROM stud_hobby) t 
	WHERE 12 * extract(year from age(stho.date_finish, stho.date_start))+ extract(month from age(stho.date_finish, stho.date_start)) = t.t_date_diff) t1
WHERE t1.t1_id_ho = hobby.id and stud.n_z = t1.n_z1

--N.8
SELECT hobby.name
FROM hobby,
	(SELECT stho.id_hobby as t3_stho_id
	FROM stud_hobby stho,
		(SELECT stud.n_z as t2_n_z
		FROM student stud,
			(SELECT MAX(stud.score) as t_sc
			FROM student stud) t1
		WHERE stud.score = t1.t_sc) t2
	WHERE t2.t2_n_z = stho.n_z) t3
WHERE t3.t3_stho_id = hobby.id

-- N.9
SELECT hobby.name
FROM hobby,
	(SELECT stho.id_hobby as id_hob
	FROM stud_hobby stho,
		(SELECT stud.n_z as n_z
		FROM student stud
		WHERE stud.score < 4.7 and stud.uni_group >1999 and stud.uni_group<3000) t
	WHERE stho.n_z = t.n_z
	GROUP BY id_hob) t1
WHERE hobby.id = t1.id_hob

-- N.10 50 процентов нигде не набралось, поэтому хотя бы 25%
SELECT t5.course
FROM
	(SELECT stud.uni_group/1000 as course, COUNT(stud.uni_group) as coun
	FROM student stud,
		(SELECT stho.n_z as n_z, COUNT(stho.n_z) as coun
		FROM stud_hobby stho,
			(SELECT stho.n_z as n_z, COUNT(stho.n_z) as t_count
			FROM stud_hobby stho
			GROUP BY stho.n_z) t
		WHERE t.t_count > 1 and t.n_z = stho.n_z
		GROUP BY stho.n_z) t1
	WHERE t1.n_z = stud.n_z
	GROUP BY stud.uni_group) t4,

	(SELECT t3.course as course, COUNT(t3.course) as course_count
	FROM (SELECT stud.uni_group/1000 as course
		FROM student stud) t3
	GROUP BY t3.course) t5
WHERE t5.course_count*0.25 <= t4.coun and t5.course = t4.course