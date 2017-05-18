# ocr

Data architecture and modeling solution for optical character recognition


## Enitity Relationship Diagram & Big Data Architecture Solution

Proposed data model design enable dynamic document metadata creation. The design supports: 
* New documents with different page metadata with different number and type of text fields 
* Text desciptions assoicated with a unique document id.

![OCR entity relationship diagram](https://github.com/kennylim/ocr/blob/master/diagram/ocr_entity_relationship_diagram.png)

![Big Data Architecture](https://github.com/kennylim/ocr/blob/master/diagram/big_data_architecture.png)

## OCR dashboard SQL Examples

```sql
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
WHERE j.job_id = 1
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








```

