--DONE 1.How many rows are in the data_analyst_jobs table?

SELECT COUNT(*)
FROM data_analyst_jobs;

--DONE 2.Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?

SELECT *
FROM data_analyst_jobs
LIMIT 10;
--'exxonmobil' 10th company

--DONE 3.How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location = 'TN';

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location IN ('TN', 'KY');

--DONE 4.How many postings in Tennessee have a star rating above 4?
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location = 'TN'
AND star_rating > 4;

--DONE 5.How many postings in the dataset have a review count between 500 and 1000?
SELECT count(*)
FROM data_analyst_jobs
WHERE review_count between 500 AND 1000;

--DONE 6.Show the average star rating for companies in each state. The output should show the state as state and the average rating for the state as avg_rating. Which state shows the highest average rating?
SELECT
location AS state,
company,
round(AVG(star_rating),2) AS avg_rating
FROM data_analyst_jobs
WHERE star_rating IS NOT NULL
GROUP BY location, company
ORDER BY avg_rating desc,
location asc;

--DONE 7.Select unique job titles from the data_analyst_jobs table. How many are there?
SELECT
count(distinct title)
FROM data_analyst_jobs;

--DONE 8.How many unique job titles are there for California companies?
SELECT
count(distinct title)
FROM data_analyst_jobs
WHERE location = 'CA';

--DONE 9.Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?
WITH top_companies AS
(select distinct company,
round(avg(star_rating),2) as avg_rating
from data_analyst_jobs
where star_rating is not null AND
company is not null AND
review_count > 5000
group by company, review_count
order by avg_rating desc,
company asc)

Select count(*)
from top_companies;

--DONE 10.Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?
select distinct company,
	round(avg(star_rating),2) as avg_rating
from data_analyst_jobs
where (star_rating is not null
	AND company is not null
	AND review_count > 5000)
group by company
order by avg_rating desc;



SELECT DISTINCT (company), 
	AVG(star_rating) AS avg_star, 
	SUM(review_count)AS sum_review
FROM data_analyst_jobs
WHERE company IS NOT NULL
	AND star_rating IS NOT NULL
GROUP BY company
HAVING SUM(review_count)>5000
ORDER BY avg_star DESC;


--DONE 11.Find all the job titles that contain the word ‘Analyst’. How many different job titles are there?
SELECT title,
count(title)
FROM data_analyst_jobs
WHERE title ILIKE ('%nalyst%')
GROUP BY title
order by count desc;

SELECT title
FROM data_analyst_jobs
WHERE LOWER(title) LIKE ('%analyst%');
--upper can be used also

--DONE 12.How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?
SELECT title
FROM data_analyst_jobs
WHERE title NOT ILIKE ('%naly%')
GROUP BY title;
--All have "Tableau" in common

--DONE BONUS.You want to understand which jobs requiring SQL are hard to fill.
--Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks.
--Disregard any postings where the domain is NULL.
--Order your results so that the domain with the greatest number of hard to fill jobs is at the top.
--Which three industries are in the top 4 on this list?How many jobs have been listed for more than 3 weeks for each of the top 4?

SELECT domain,
COUNT(title)
FROM data_analyst_jobs
WHERE skills ILIKE ('%SQL%')
AND days_since_posting >= 21
AND domain IS NOT Null
GROUP BY domain
ORDER BY COUNT(title) DESC 
LIMIT 4;


--window function example
SELECT title, 
	domain, 
	days_since_posting,
	COUNT(*) OVER(PARTITION BY domain) AS hard_to_fill
FROM data_analyst_jobs
WHERE skills LIKE '%SQL%'
AND days_since_posting > 21
AND domain IS NOT NULL 
ORDER BY hard_to_fill DESC;