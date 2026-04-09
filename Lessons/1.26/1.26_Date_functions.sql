SELECT 
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME AS time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMPTZ AS timestamptz -- BE AWARE! if no TZ was saved before it goes with your TZ! It might be wrong
FROM data_jobs.job_postings_fact
LIMIT 10;

-- EXTRACT
SELECT 
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    EXTRACT(DAY FROM job_posted_date) AS job_posted_day
FROM data_jobs.job_postings_fact
LIMIT 10;


SELECT 
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM data_jobs.job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    EXTRACT(YEAR FROM job_posted_date),
    EXTRACT(MONTH FROM job_posted_date)
ORDER BY 1,2;

-- DATE TRUNC

SELECT
    job_posted_date,
    DATE_TRUNC('year', job_posted_date) AS truncated_year,
    DATE_TRUNC('quarter', job_posted_date) AS truncated_quarter,
    DATE_TRUNC('month', job_posted_date) AS truncated_month,
    DATE_TRUNC('week', job_posted_date) AS truncated_week,
    DATE_TRUNC('day', job_posted_date) AS truncated_day,
    DATE_TRUNC('hour', job_posted_date) AS truncated_hour
FROM data_jobs.job_postings_fact
ORDER BY RANDOM()
LIMIT(10);

-- AT TIME ZONE
SELECT
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ;

SELECT
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' -- original data was in UTC timezone
FROM data_jobs.job_postings_fact;

-- Small analysis of the time of the day, when jobs were posted
SELECT
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC') AS job_posted_hour_utc,
    COUNT(job_id)
FROM data_jobs.job_postings_fact
WHERE 
    LOWER(job_location) LIKE '%london%'
GROUP BY 
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC')
ORDER BY 1;