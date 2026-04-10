-- Count Rows - Aggregation Only
SELECT
    COUNT(*)
FROM
    data_jobs.job_postings_fact;

-- Count Rows - Window Function
SELECT
    job_id,
    COUNT(*) OVER()
FROM
    data_jobs.job_postings_fact;

-- PARTITION BY - Find hourly salary
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    company_id,
    AVG(salary_hour_avg) OVER
        (
            PARTITION BY job_title_short, company_id
        )
FROM
    data_jobs.job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY RANDOM() -- for example purposes only
LIMIT 10;

-- ORDER BY - Ranking hourly salary
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER
        (
            ORDER BY salary_hour_avg DESC
        ) AS rank_hourly_salary
FROM
    data_jobs.job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC
LIMIT 10;


-- PARTITION BY & ORDER BY - Running average hourly salary
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER
        (
            PARTITION BY job_title_short
            ORDER BY job_posted_date
        ) AS running_avg_hourly_by_title
FROM
    data_jobs.job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
    AND job_title_short = 'Data Engineer'
ORDER BY
    job_title_short,
    job_posted_date
LIMIT 10;


-- PARTITION BY & ORDER BY - Ranking average hourly salary by job_title_short
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER
        (
            PARTITION BY job_title_short
            ORDER BY salary_hour_avg DESC
        ) AS running_avg_hourly_by_titlerank_hourly_salary
FROM
    data_jobs.job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;


-- LAG & LEAD - Time based comparison of company tearly salary
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER -- LEAD is very similar, but goes to the next value in partition, not the previous
        (
            PARTITION BY company_id
            ORDER BY job_posted_date
        ) AS prev_posted_salary,
    salary_year_avg -
    LAG(salary_year_avg) OVER
        (
            PARTITION BY company_id
            ORDER BY job_posted_date
        ) AS salary_change_to_prev
FROM
    data_jobs.job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
ORDER BY
    company_id,
    job_posted_date
LIMIT 60;