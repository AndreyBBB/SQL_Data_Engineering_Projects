-- UNION
SELECT UNNEST([1,1,1,2])
UNION
SELECT UNNEST([1,1,3]);
-- delete duplicates

SELECT UNNEST([1,1,1,2])
UNION ALL
SELECT UNNEST([1,1,3]);

-- INTERSECT
SELECT UNNEST([1,1,1,2])
INTERSECT
SELECT UNNEST([1,1,3]);
-- delete duplicates

SELECT UNNEST([1,1,1,2])
INTERSECT ALL
SELECT UNNEST([1,1,3]); 
-- THE RESULS HAS ONLY 2 times '1', as the third one isn't in intersection. we can interpret it as row-by-row comparison


-- EXCEPT
SELECT UNNEST([1,1,1,2])
EXCEPT
SELECT UNNEST([1,1,3]);
-- delete duplicates

SELECT UNNEST([1,1,1,2])
EXCEPT ALL
SELECT UNNEST([1,1,3]); 
-- THE RESULS HAS ONLY '1' and '2', as the third '1' is only in A, not in B. we can interpret it as row-by-row deletion


-- Final Example
CREATE TEMP TABLE jobs_2023 AS
SELECT * EXCLUDE (job_id, job_posted_date) -- DuckDB feature, might not work in other DB
FROM data_jobs.job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

CREATE TEMP TABLE jobs_2024 AS
SELECT * EXCLUDE (job_id, job_posted_date) -- DuckDB feature, might not work in other DB
FROM data_jobs.job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

-- Which unique job postings appeared in either 2023 or 2024?
SELECT * FROM jobs_2023
UNION
SELECT * FROM jobs_2024;

SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) AS record_count
FROM 
    jobs_2023
UNION
SELECT 
    'jobs_2024' AS table_name,
    COUNT(*) AS record_count
FROM jobs_2024;


-- Which job postings appeared across both years, counting duplicates?
SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;


-- Which job postings appeared in 2023 but not in 2024?
SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;


-- Which job postings from 2023 remain after substracting matching 2024 postings, one-for-one?
SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;


-- Which job postings appeared in both 2023 and 2024?
SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;


-- Which job postings appeared in both 2023 and 2024, preserving duplicate counts?
SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;