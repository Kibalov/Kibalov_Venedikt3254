1. SELECT 'amogus'

2. SELECT CURRENT_DATE

3.
WITH mynums (var1, var2) as (
	values(5, 3)
)
SELECT var1 + var2, var1 * var2, var1 / var2, var1 - var2
FROM mynums

CREATE OR REPLACE FUNCTION calculate(var1 int, var2 int) RETURNS int
AS $$
DECLARE result int;
BEGIN
	RETURN var1 + var2;
END
$$ LANGUAGE plpgsql;

SELECT calculate(2, 4);

4.
DO $BODY$
DECLARE var int := 1;
BEGIN
	IF var = 5 THEN
		RAISE NOTICE 'Отлично!';
	ELSIF var = 4 THEN
		RAISE NOTICE 'Хорошо!';
	ELSIF var = 3 THEN
		RAISE NOTICE 'Удовлетворительно!';
	ELSIF var = 2 THEN
		RAISE NOTICE 'Неудовлетворительно!';
	ELSE RAISE NOTICE 'Неверная оценка!';
	END IF;
END;
$BODY$;

DO $BODY$
DECLARE var int := 3;
BEGIN
	CASE var
		WHEN 5 THEN RAISE NOTICE 'Отлично';
		WHEN 4 THEN RAISE NOTICE 'Хорошо';
		WHEN 3 THEN RAISE NOTICE 'Удовлетворительно';
		WHEN 2 THEN RAISE NOTICE 'Неудовлетворительно';
		ELSE RAISE NOTICE 'Не оценка';
	END CASE;
END;
$BODY$;


5.
DO $$
BEGIN
	FOR i IN 20..30 LOOP
		RAISE NOTICE '%^2= %', i, i*i;
	END LOOP;
END;
$$;

DO $$
DECLARE i int := 20;
BEGIN
	WHILE i <= 30 LOOP
		RAISE NOTICE '%^2= %', i, i*i;
		i = i + 1;
	END LOOP;
END;
$$;

6.
DO $$
DECLARE num int := 123; i int :=0;
BEGIN
	WHILE num != 1 LOOP
		CASE num%2
			WHEN 0 THEN num := num/2;
			WHEN 1 THEN num := num*3+1;
		END CASE;
		i = i + 1;
	END LOOP;
	RAISE NOTICE 'count:% num:%', i, num;
END;
$$;

7.
CREATE OR REPLACE PROCEDURE luke_number(num int)
LANGUAGE plpgsql
AS $$
DECLARE ln1 int :=2;ln2 int :=1;ln3 int :=0;
BEGIN
	num = num - 2;
	RAISE NOTICE '%', ln1;
	RAISE NOTICE '%', ln2;
	WHILE num != 0 LOOP
		ln3 = ln1 + ln2;
		ln1 = ln2;
		ln2 = ln3;
		RAISE NOTICE '%', ln3;
		num = num - 1;
	END LOOP;
END;
$$;

CALL luke_number(5)


8.
CREATE OR REPLACE FUNCTION count_users_by_year(year int) RETURNS int
AS $$
DECLARE var int;
BEGIN
	SELECT COUNT(birth_date) INTO var
	FROM people
	WHERE extract(year from birth_date) = year;
	RETURN var;
END
$$ LANGUAGE plpgsql;

SELECT count_users_by_year(1995);

9.
CREATE OR REPLACE FUNCTION count_users_by_eyes(color varchar) RETURNS int
AS $$
DECLARE var int;
BEGIN
	SELECT COUNT(eyes) INTO var
	FROM people
	WHERE eyes = color;
	RETURN var;
END
$$ LANGUAGE plpgsql;

SELECT count_users_by_eyes('blue')

10.
CREATE OR REPLACE FUNCTION most_young_user_id() RETURNS int
AS $$
DECLARE var int;
BEGIN
	SELECT people.id INTO var
	FROM people, 
		(SELECT MAX(birth_date) as bid
		FROM people) t
	WHERE birth_date = t.bid;
	
	RETURN var;
END
$$ LANGUAGE plpgsql;

SELECT most_young_user_id()

11.
CREATE OR REPLACE FUNCTION users_over_IMT(imt int) RETURNS SETOF people 
AS $$
DECLARE var int;
BEGIN
	RETURN QUERY
		SELECT *
		FROM people
		WHERE weight / ((growth/100)^2) > imt;
END
$$ LANGUAGE plpgsql;

SELECT * FROM users_over_IMT(25)

12.
BEGIN;
CREATE TABLE IF NOT EXISTS relations (
  id1 INT NOT NULL,
  id2 INT NOT NULL,
  relation_type VARCHAR(45) NOT NULL,
  PRIMARY KEY (id1, id2, relation_type));
COMMIT;

13.
CREATE OR REPLACE PROCEDURE add_relations(id01 int, id02 int, rel_type varchar)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO relations (id1, id2, relation_type)
	VALUES(id01, id02, rel_type);
END;
$$;

CALL add_relations(4, 5, 'sisters')

14.
BEGIN; 
ALTER TABLE people ADD COLUMN relevance_date DATE; 
COMMIT;

15.
CREATE OR REPLACE PROCEDURE update_body(people_id int, growth1 real, weight1 real)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE people
	SET growth = growth1, weight = weight1, relevance_date = CURRENT_DATE
	WHERE people.id = people_id;
END;
$$;

CALL update_body(1, 180.3, 81.7);
