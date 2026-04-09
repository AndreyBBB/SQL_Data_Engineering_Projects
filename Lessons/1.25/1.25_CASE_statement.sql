-- Bucket Salaries
-- <25 = 'Low'
-- 25-50 = 'Medium'
-- >50 = 'High'

SELECT
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg < 25 THEN 'Low'
        WHEN salary_hour_avg <= 50 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM data_jobs.job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;

-- Handling Missing Data (NULLs)
-- Filter NULL salary values
SELECT
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg IS NULL THEN 'Missing'
        WHEN salary_hour_avg < 25 THEN 'Low'
        WHEN salary_hour_avg <= 50 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM data_jobs.job_postings_fact
LIMIT 10;

-- Categorizing Categorical Values
-- Classify the 'job_title' column values as:
    -- 'Data Analyst'
    -- 'Data Engineer'
    -- 'Data Scientist'

SELECT
    job_title,
    CASE
        WHEN LOWER(job_title) LIKE '%data%' AND LOWER(job_title) LIKE '%analyst%' THEN 'Data Analyst'
        WHEN LOWER(job_title) LIKE '%data%' AND LOWER(job_title) LIKE '%engineer%' THEN 'Data Analyst'
        WHEN LOWER(job_title) LIKE '%data%' AND LOWER(job_title) LIKE '%scientist%' THEN 'Data Analyst'
        ELSE 'Other'
    END AS job_title_category,
    job_title_short
FROM data_jobs.job_postings_fact
ORDER BY RANDOM() -- specific function, works only in DuckDB, SQLite and Postgres
LIMIT 20;

-- Conditional Aggregation
-- Calculate Median Salaries for Different Buckets
    -- < $100K
    -- >= $100K

SELECT
    job_title_short,
    COUNT(*) AS total_postings,
    MEDIAN
        (
            CASE
                WHEN salary_year_avg < 100_000 THEN salary_year_avg
            END
        ) AS median_low_salary,
    MEDIAN
        (
            CASE
                WHEN salary_year_avg >= 100_000 THEN salary_year_avg
            END
        ) AS median_highsalary    
FROM data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short;

-- Final Example: Conditional Calculations
-- Compute a standartized_salary using yearly salary and adjusted hourly salary (e.g. 20280 hours|year)
-- Categorize salaries into tiers of:
    -- <75K = 'Low'
    -- 75K-150K = 'Medium'
    -- >=150K = 'High'

WITH salaries AS
(
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
        END AS standartized_salary
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL 
        OR salary_hour_avg IS NOT NULL
)
SELECT
    *,
    CASE
        WHEN standartized_salary IS NULL THEN 'Missing'
        WHEN standartized_salary < 75_000 THEN 'Low'
        WHEN standartized_salary < 150_000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM salaries
ORDER BY standartized_salary DESC
LIMIT 20;