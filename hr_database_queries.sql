SELECT * FROM hrdata;

--Employee Count:
SELECT SUM(employee_count) 
AS Employee_Count 
FROM hrdata;

--Attrition Count:
SELECT COUNT(attrition) 
FROM hrdata 
WHERE attrition='Yes';

--Attrition Rate:
SELECT ROUND(((SELECT COUNT(attrition) 
FROM hrdata 
WHERE attrition='Yes')/ 
SUM(employee_count)) * 100,2)
FROM hrdata;

--Active Employee:
SELECT SUM(employee_count) - 
(SELECT COUNT(attrition) FROM hrdata 
WHERE attrition='Yes') FROM hrdata;
--OR
SELECT (SELECT SUM(employee_count) 
FROM hrdata) - COUNT(attrition) AS active_employee 
FROM hrdata
WHERE attrition='Yes';

--Average Age:
SELECT ROUND(AVG(age),2) AS Average_Age
FROM hrdata;

--Attrition by Gender
SELECT gender, COUNT(attrition) 
AS attrition_count 
FROM hrdata
WHERE attrition='Yes'
GROUP BY gender
ORDER BY COUNT(attrition) DESC;

--Department wise Attrition:
SELECT department, COUNT(attrition), 
ROUND((CAST (COUNT(attrition) 
AS NUMERIC) / 
(SELECT COUNT(attrition)
FROM hrdata 
WHERE attrition= 'Yes')) * 100, 2) 
AS pct 
FROM hrdata
WHERE attrition='Yes'
GROUP BY department 
ORDER BY COUNT(attrition) desc;

--No of Employee by Age Group
SELECT age,  sum(employee_count) AS employee_count FROM hrdata
GROUP BY age
ORDER BY age;

--Education Field wise Attrition:
SELECT education_field, COUNT(attrition) 
AS attrition_count FROM hrdata
WHERE attrition='Yes'
GROUP BY education_field
ORDER BY COUNT(attrition) DESC;

--Attrition Rate by Gender for different Age Group
SELECT age_band, gender, COUNT(attrition) AS attrition, 
ROUND((CAST(COUNT(attrition) AS NUMERIC) / 
(SELECT COUNT(attrition)
FROM hrdata 
WHERE attrition = 'Yes')) * 100,2) as pct
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY age_band, gender
ORDER BY age_band, gender desc;

--Job Satisfaction Rating
-- CREATE EXTENSION IF NOT EXISTS tablefunc;
--
SELECT *
FROM crosstab(
  'SELECT job_role, job_satisfaction, sum(employee_count)
   FROM hrdata
   GROUP BY job_role, job_satisfaction
   ORDER BY job_role, job_satisfaction'
	) AS ct(job_role VARCHAR(50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role;

--Job Satisfaction
SELECT job_role, job_satisfaction, sum(employee_count) AS employee_count
FROM hrdata
GROUP BY job_role, job_satisfaction
ORDER BY job_role, job_satisfaction;

--Education Field and Job Role wise Attrition
SELECT education_field, job_role, COUNT(attrition) AS attrition_count
FROM hrdata
WHERE attrition='Yes'
GROUP BY education_field, job_role
ORDER BY education_field, job_role;

--Education Field and Job Role wise Attrition Rate
SELECT education_field, job_role, COUNT(attrition) AS attrition_count,
ROUND((CAST(COUNT(attrition) AS NUMERIC) /
(SELECT COUNT(attrition)
FROM hrdata
WHERE attrition='Yes')) * 100,2) AS pct
FROM hrdata
WHERE attrition='Yes'
GROUP BY education_field, job_role
ORDER BY education_field, job_role;

--Attrition Rate by Job Role
SELECT job_role, COUNT(attrition) AS attrition_count,
ROUND((CAST(COUNT(attrition) AS NUMERIC) /
(SELECT COUNT(attrition)
FROM hrdata
WHERE attrition='Yes')) * 100,2) AS pct
FROM hrdata
WHERE attrition='Yes'
GROUP BY job_role
ORDER BY job_role;