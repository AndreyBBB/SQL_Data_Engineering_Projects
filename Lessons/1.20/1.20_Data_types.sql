select
    table_name,
    column_name,
    data_type
from information_schema.columns
where table_name = 'job_postings_fact';

DESCRIBE -- doesn't work in Postgres or SQL Server
select  
    job_title_short,
    salary_year_avg
from job_postings_fact;

select cast(123 as varchar);

select
    job_id, -- "more unique" identifier
    job_work_from_home, -- from boolean to numeric
    job_posted_date, -- from timestamp to date only
    salary_year_avg -- from double to no decimal places
from
    job_postings_fact
limit 10;

-- operator :: (same as CAST) - works in DuckDB and some other DBs
-- CAST works everywhere
-- || = concatenate

--explain
select
    job_id :: varchar || '-' || -- "more unique" identifier
    company_id :: varchar as combined_id, -- added to create a surrogate id combining with job_id
    job_work_from_home :: int as work_from_home, -- from boolean to numeric 
    CAST(job_posted_date AS date) as date_posted, -- from timestamp to date only
    CAST(salary_year_avg as DECIMAL(10,0)) as avg_salary_int-- from double to no decimal places
from
    job_postings_fact
where salary_year_avg is not null
limit 10;