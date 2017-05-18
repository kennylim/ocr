
DROP SCHEMA ocr CASCADE;
CREATE SCHEMA ocr;


DROP TABLE IF EXISTS ocr.customer CASCADE;
CREATE TABLE ocr.customer(
	customer_id serial NOT NULL,
	name varchar(50) NOT NULL,
	email varchar(50) NOT NULL,
	password varchar(50) NOT NULL,
	phone_number varchar(50),
	account_type varchar(50) NOT NULL,
	field_limit integer NOT NULL,
	created_at timestamptz,
	CONSTRAINT customer_id_pk PRIMARY KEY (customer_id)

);


DROP TABLE IF EXISTS ocr."user" CASCADE;
CREATE TABLE ocr."user"(
	user_id serial NOT NULL,
	customer_id integer,
	name varchar(50) NOT NULL,
	email varchar(50) NOT NULL,
	password varchar(50) NOT NULL,
	role varchar(50) NOT NULL,
	created_at timestamptz,
	CONSTRAINT user_id_pk PRIMARY KEY (user_id)

);

DROP TABLE IF EXISTS ocr.job CASCADE;
CREATE TABLE ocr.job(
	job_id serial NOT NULL,
	user_id integer,
	job_name varchar(50) NOT NULL,
	start_time timestamptz,
	end_time timestamptz,
	status varchar(50),
	CONSTRAINT job_id_pk PRIMARY KEY (job_id)

);

DROP TABLE IF EXISTS ocr.batch CASCADE;
CREATE TABLE ocr.batch(
	batch_id serial NOT NULL,
	job_id integer,
	batch_name varchar(50) NOT NULL,
	start_time timestamptz,
	end_time timestamptz,
	status varchar(50),
	CONSTRAINT batch_id_pk PRIMARY KEY (batch_id)

);

DROP TABLE IF EXISTS ocr.document CASCADE;
CREATE TABLE ocr.document(
	document_id serial NOT NULL,
	customer_id integer,
	job_id integer,
	document_name varchar(50) NOT NULL,
	total_fields varchar(50),
	create_at timestamptz,
	CONSTRAINT document_id_pk PRIMARY KEY (document_id)

);

DROP TABLE IF EXISTS ocr.page CASCADE;
CREATE TABLE ocr.page(
	page_id serial NOT NULL,
	batch_id integer,
	document_id integer,
	image_name varchar(50) NOT NULL,
	create_at timestamptz,
	CONSTRAINT page_id_pk PRIMARY KEY (page_id)

);

DROP TABLE IF EXISTS ocr.field CASCADE;
CREATE TABLE ocr.field(
	field_id serial,
	document_id integer,
	field_name varchar(50),
	data_type varchar(50),
	comments varchar(50),
	created_at timestamptz
);

DROP TABLE IF EXISTS ocr.result CASCADE;
CREATE TABLE ocr.result(
	result_id serial NOT NULL,
	customer_id integer,
	job_id integer,
	batch_id integer,
	page_id integer,
	field_id integer,
	data VARCHAR(100) NOT NULL,
	status varchar(50),
	created_at timestamptz,
	CONSTRAINT result_id_pk PRIMARY KEY (result_id)

);


ALTER TABLE ocr."user" DROP CONSTRAINT IF EXISTS customer_id_fk CASCADE;
ALTER TABLE ocr."user" ADD CONSTRAINT customer_id_fk FOREIGN KEY (customer_id)
REFERENCES ocr.customer (customer_id);

ALTER TABLE ocr.job DROP CONSTRAINT IF EXISTS user_id_fk CASCADE;
ALTER TABLE ocr.job ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id)
REFERENCES ocr."user" (user_id);

ALTER TABLE ocr.batch DROP CONSTRAINT IF EXISTS job_id_fk CASCADE;
ALTER TABLE ocr.batch ADD CONSTRAINT job_id_fk FOREIGN KEY (job_id)
REFERENCES ocr.job (job_id);

ALTER TABLE ocr.document DROP CONSTRAINT IF EXISTS customer_id_fk CASCADE;
ALTER TABLE ocr.document ADD CONSTRAINT customer_id_fk FOREIGN KEY (customer_id)
REFERENCES ocr.customer (customer_id);

ALTER TABLE ocr.page DROP CONSTRAINT IF EXISTS batch_id_fk CASCADE;
ALTER TABLE ocr.page ADD CONSTRAINT batch_id_fk FOREIGN KEY (batch_id)
REFERENCES ocr.batch (batch_id);

ALTER TABLE ocr.page DROP CONSTRAINT IF EXISTS document_id_fk CASCADE;
ALTER TABLE ocr.page ADD CONSTRAINT document_id_fk FOREIGN KEY (document_id)
REFERENCES ocr.document (document_id);

ALTER TABLE ocr.field DROP CONSTRAINT IF EXISTS document_id_fk CASCADE;
ALTER TABLE ocr.field ADD CONSTRAINT document_id_fk FOREIGN KEY (document_id)
REFERENCES ocr.document (document_id);

ALTER TABLE ocr.result DROP CONSTRAINT IF EXISTS page_id_fk CASCADE;
ALTER TABLE ocr.result ADD CONSTRAINT page_id_fk FOREIGN KEY (page_id)
REFERENCES ocr.page (page_id);

-- customer data
INSERT INTO ocr.customer (customer_id, name, email, password, phone_number, account_type, field_limit, created_at) VALUES(1,'capricity','admin@ocr.com', 'fds^&@d1343', '7403821123','admin','100000',now());
INSERT INTO ocr.customer (customer_id, name, email, password, phone_number, account_type, field_limit, created_at)  VALUES(2,'zeebo','tom.lee@gmail.com', '72dfdfj!3ds', '6507241111','user','1000',now());
INSERT INTO ocr.customer (customer_id, name, email, password, phone_number, account_type, field_limit, created_at)  VALUES(3,'tepher','barry.jones@tepher.com', 's7271!@#vdd', '6714241111','user','100',now());

-- user data
INSERT INTO ocr.user (user_id, customer_id, name, email, password, role, created_at)
VALUES (1,1,'admin','admin@ocr.com','ads^&@241','admin', now());
INSERT INTO ocr.user (user_id, customer_id, name, email, password, role, created_at)
VALUES (2,2,'tomlee','tom.lee@gmail.com','1ds^&@d1241','user', now());
INSERT INTO ocr.user (user_id, customer_id, name, email, password, role, created_at)
VALUES (3,3,'barryjones','barry.jones@tepher.com','ABC^&@d12','user', now());

-- job data
INSERT INTO ocr.job (job_id, user_id, job_name, start_time, end_time)
VALUES (1,2,'job 1', now()-'1 hour'::interval, now());
INSERT INTO ocr.job (job_id, user_id, job_name, start_time, end_time)
VALUES (2,2,'job 2', now()-'3 hour'::interval, now());
INSERT INTO ocr.job (job_id, user_id, job_name, start_time, end_time)
VALUES (3,3,'job 3', now()-'4 hour'::interval, now());


-- batch date
 --job 1
INSERT INTO ocr.batch (job_id, batch_name, start_time, end_time)
VALUES (1,'batch 1', now()-'2 hour'::interval, now());
INSERT INTO ocr.batch (job_id, batch_name, start_time,end_time)
VALUES (1,'batch 2', now()-'2 hour'::interval, now());
INSERT INTO ocr.batch (job_id, batch_name, start_time,end_time)
VALUES (1,'batch 3', now()-'2 hour'::interval, now());

INSERT INTO ocr.batch (job_id, batch_name, start_time, end_time)
VALUES (1,'batch 4', now()-'2 hour'::interval, now());
INSERT INTO ocr.batch (job_id, batch_name, start_time,end_time)
VALUES (1,'batch 5', now()-'2 hour'::interval, now());
INSERT INTO ocr.batch (job_id, batch_name, start_time,end_time)
VALUES (1,'batch 6', now()-'2 hour'::interval, now());

-- job 2
INSERT INTO ocr.batch (job_id, batch_name, start_time, end_time)
VALUES (2,'batch 7', now()-'5 hour'::interval, now());
INSERT INTO ocr.batch (job_id, batch_name, start_time,end_time)
VALUES (2,'batch 8', now()-'4 hour'::interval, now());
INSERT INTO ocr.batch (job_id, batch_name, start_time,end_time)
VALUES (2,'batch 9', now()-'3 hour'::interval, now());
INSERT INTO ocr.batch (job_id, batch_name, start_time,end_time)
VALUES (2,'batch 10', now()-'2 hour'::interval, now());

-- job 3
INSERT INTO ocr.batch (job_id, batch_name, start_time, end_time)
VALUES (3,'batch 11', now()-'5 hour'::interval, now());


--user 2
INSERT INTO ocr.document (customer_id, job_id, document_name, total_fields, create_at)
VALUES (2,1,'patient_signup',5, now());
INSERT INTO ocr.document (customer_id, job_id, document_name, total_fields, create_at)
VALUES (2,1,'patient_disclaimer',4, now());

INSERT INTO ocr.document (customer_id, job_id, document_name, total_fields, create_at)
VALUES (2,2,'patient_signup',5, now());
INSERT INTO ocr.document (customer_id, job_id, document_name, total_fields, create_at)
VALUES (2,2,'patient_disclaimer',4, now());

--user 3
INSERT INTO ocr.document (customer_id, job_id, document_name, total_fields, create_at)
VALUES (3,3,'patient_signup',5, now());



-- page data
-- user 2
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (1,1,'ken_lee_signup.jpg',now());
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (2,1,'donna_jones_signup.jpg',now());
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (3,1,'john_sebastian_signup.jpg',now());
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (4,2,'ken_lee_disclaimer.jpg',now());
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (5,2,'donna_jones_disclaimer.jpg',now());
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (6,2,'john_sebastian_disclaimer.jpg',now());


INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (7,1,'johnny_tan_signup.jpg',now());
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (8,1,'mary_henderson_signup.jpg',now());

INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (9,2,'johnny_tan_disclaimer.jpg',now());
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (10,2,'mary_henderson_disclaimer.jpg',now());

-- user 3
INSERT INTO ocr.page (batch_id, document_id, image_name, create_at)
VALUES (11,3,'sabine_finch_signup.jpg',now());


-- field data
--user 2
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (1, 'first_name','text',null, now());
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (1, 'last_name','text',null, now() );
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (1, 'email','text',null, now());
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (1, 'phone','number',null, now());
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (1, 'signup_date','timestamp',null, now() );

INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (2, 'first_name','text',null, now() );
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (2, 'last_name','text',null, now() );
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (2, 'signature','text',null, now() );
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (2, 'signature_date','timestamp',null, now() );

--user 3

INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (3, 'first_name','text',null, now());
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (3, 'last_name','text',null, now() );
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (3, 'email','text',null, now());
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (3, 'phone','number',null, now());
INSERT INTO ocr.field (document_id, field_name, data_type, comments, created_at)
VALUES (3, 'signup_date','timestamp',null, now() );


-- result data
-- patient signup: job 1

INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 1, 1, 1,'Ken','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 1, 1, 2,'Lee','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 1, 1, 3,'me@kenlee.com','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 1, 1, 4,'678-223-1832','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 1, 1, 5, now(),'insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 2, 2, 1,'Donna','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 2, 2, 2,'Jones','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 2, 2, 3,'donna@gmail.com','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 2, 2, 4,'415-893-2332','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 2, 2, 5,  now(),'insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 3, 3, 1,'John','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 3, 3, 2,'Sebastian','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 3, 3, 3,'johnsebastian@yahoo.com','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 3, 3, 4,'510-221-1111','insert', now() );

INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 3, 3, 5, now(),'insert', now() );


-- patient signature: job 1

INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 4, 4, 1,'Ken','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 4, 4, 2,'Lee','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 4, 4, 3,'Ken Lee','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 4, 4, 4, now(),'insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 5, 5, 1,'Donna','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 5, 5, 2,'Jones','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 5, 5, 3,'Donna Jones','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 5, 5, 4, now(),'insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 6, 6, 1,'John','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 6, 6, 2,'Sebastian','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 6, 6, 3,'John Sebastian','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 1, 6, 6, 4, now(),'insert', now() );


-- patient signup: job 2

INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 7, 7, 1,'Johnny','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 7, 7, 2,'Tan','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 7, 7, 3,'johnny_tan@yahoo.com','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 7, 7, 4,'450-123-1222','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 7, 7, 5, now(),'insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 8, 8, 1,'Mary','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 8, 8, 2,'Henderson','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 8, 8, 3,'maryhenderson@gmail.com','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 8, 8, 4,'650-771-2232','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 8, 8, 5,  now(),'insert', now() );

-- patient signature: job 2

INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 9, 9, 1,'Johnny','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 9, 9, 2,'Tan','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 9, 9, 3,'Johnny Tan','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 9, 9, 4, now(),'insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 10, 10, 1,'Mary','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 10, 10, 2,'Henderson','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 10, 10, 3,'Mary Henderson','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (2, 2, 10, 10, 4, now(),'insert', now() );

-- patient signup: job 3

INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (3, 3, 11, 11, 1,'Sabine','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (3, 3, 11, 11, 2,'Finch','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (3, 3, 11, 11, 3,'sabine_finch@yahoo.com','insert', now());
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (3, 3, 11, 11, 4,'770-523-1897','insert', now() );
INSERT INTO ocr.result (customer_id, job_id, batch_id, page_id, field_id, data, status, created_at)
VALUES (3, 3, 11, 11, 5,  now(),'insert', now() );


--  1a. Percentage of completion all or a specific batch associated with a job

SELECT j.job_id,
       j.job_name,
       b.batch_name,
       p.image_name,
       count(f.field_id::float) AS total_fields,
       count(r.batch_id::float) AS total_field_processed,
       count(r.batch_id::float)/(count(f.field_id::float))*100 AS batch_pct_complete
FROM ocr.result AS r
INNER JOIN ocr.batch AS b ON b.batch_id = r.batch_id
INNER JOIN ocr.job AS j ON j.job_id = b.job_id
INNER JOIN ocr.page AS p ON p.page_id = r.page_id
INNER JOIN ocr.document AS d ON d.document_id = p.document_id
INNER JOIN ocr.field AS f ON f.field_id = r.field_id
--WHERE j.job_id = 1
--AND b.batch_id = 2
GROUP BY j.job_id,
         j.job_name,
         b.batch_name,
         p.image_name,
         d.total_fields
ORDER BY job_name;


 job_id | job_name | batch_name |          image_name           | total_fields | total_field_processed | batch_pct_complete
--------+----------+------------+-------------------------------+--------------+-----------------------+--------------------
      1 | job 1    | batch 1    | ken_lee_signup.jpg            |            5 |                     5 |                100
      1 | job 1    | batch 2    | donna_jones_signup.jpg        |            5 |                     5 |                100
      1 | job 1    | batch 3    | john_sebastian_signup.jpg     |            5 |                     5 |                100
      1 | job 1    | batch 4    | ken_lee_disclaimer.jpg        |            4 |                     4 |                100
      1 | job 1    | batch 5    | donna_jones_disclaimer.jpg    |            4 |                     4 |                100
      1 | job 1    | batch 6    | john_sebastian_disclaimer.jpg |            4 |                     4 |                100


--1b. Percentage of completion all or a specific job

SELECT j.job_id,
       j.job_name,
       count(f.field_id::float) AS total_fields,
       count(r.batch_id::float) AS total_field_processed,
       count(r.batch_id::float)/(count(f.field_id::float))*100 AS job_pct_complete
FROM ocr.result AS r
INNER JOIN ocr.batch AS b ON b.batch_id = r.batch_id
INNER JOIN ocr.job AS j ON j.job_id = b.job_id
INNER JOIN ocr.page AS p ON p.page_id = r.page_id
INNER JOIN ocr.document AS d ON d.document_id = p.document_id
INNER JOIN ocr.field AS f ON f.field_id = r.field_id
--WHERE j.job_id = 1
GROUP BY j.job_id
ORDER BY job_name;

-- specific job
 job_id | job_name | total_fields | total_field_processed | job_pct_complete
--------+----------+--------------+-----------------------+------------------
      1 | job 1    |           27 |                    27 |              100

-- all jobs
 job_id | job_name | total_fields | total_field_processed | job_pct_complete
--------+----------+--------------+-----------------------+------------------
      1 | job 1    |           27 |                    27 |              100
      2 | job 2    |           18 |                    18 |              100
      3 | job 3    |            5 |                     5 |              100

--2. Total time taken to digitize a job

SELECT j.job_id,
       j.job_name,
       MAX(created_at) - MIN(created_at) AS job_total_time
FROM ocr.result AS r
INNER JOIN ocr.job AS j ON j.job_id = r.job_id
WHERE batch_id IN
    (SELECT batch_id
     FROM ocr.batch b
     WHERE job_id = 1)
GROUP BY j.job_id;

 job_id | job_name | job_total_time
--------+----------+-----------------
      1 | job 1    | 00:11:58.813178


 --3. List of longest running jobs in descending order

SELECT job_id,
       job_name,
       start_time,
       end_time,
       end_time-start_time AS total_time
FROM ocr.job
ORDER BY job DESC;
 --limit 10;


job_id | job_name |         start_time         |         stop_time          | total_time
--------+----------+----------------------------+----------------------------+------------
      2 | job 2    | 2016-03-03 06:13:39.688602 | 2016-03-03 09:13:39.688602 | 03:00:00
      1 | job 1    | 2016-03-03 08:13:39.687467 | 2016-03-03 09:13:39.687467 | 01:00:00

--4.  User would want to update the values of a field in the result table.

UPDATE ocr.result
SET DATA = 'donna.jones@msn.com',
           status = 'update',
           created_at = now()
WHERE result_id = 8;



 result_id | batch_id | page_id | field_id |      data       | status |         created_at
-----------+----------+---------+----------+-----------------+--------+----------------------------
         8 |        2 |       2 |        3 | donna@gmail.com | insert | 2016-03-03 10:47:32.246975


UPDATE 1

postgres=# select * from ocr.result where result_id = 8;
result_id | batch_id | page_id | field_id |      data       | status |         created_at
-----------+----------+---------+----------+---------------------+--------+---------------------------
         8 |        2 |       2 |        3 | donna.jones@msn.com | update | 2016-03-03 10:52:57.21066

--5. An admin user should be able to get the list of largest customers (in terms of fields digitized) for a month.

SELECT c.customer_id,
       c.name,
       count(r.field_id) AS digitized_fields_by_month
FROM ocr.customer c
INNER JOIN ocr.result r ON r.customer_id = c.customer_id
AND date_part('year', r.created_at) = 2016
AND date_part('month', r.created_at) = 3
GROUP BY c.customer_id
ORDER BY digitized_fields_by_month DESC;
 --limit 10;

 customer_id |  name  | digitized_fields_by_month
-------------+--------+---------------------------
           2 | zeebo  |                        45
           3 | tepher |                         5

--6. Once a year, the admin use can generate a batch job to get the list of top customers in terms of digitization for the whole year

SELECT c.customer_id,
       c.name,
       count(r.field_id) AS digitized_fields_by_year
FROM ocr.customer c
INNER JOIN ocr.result r ON r.customer_id = c.customer_id
AND date_part('year', r.created_at) = 2016
AND date_part('year', r.created_at) = 2016
GROUP BY c.customer_id
ORDER BY digitized_fields_by_year DESC;
 --limit 10;

 customer_id |  name  | digitized_fields_by_year
-------------+--------+--------------------------
           2 | zeebo  |                       120
           3 | tepher |                        40





