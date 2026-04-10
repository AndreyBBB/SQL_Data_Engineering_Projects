-- Array Intro
SELECT [1,2,3]; -- values of the same type, under the hood all the values have their inder in an array

SELECT ['python','sql','r'] AS skills_array;

WITH skills AS
(
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
)
, skills_array AS
(
--SELECT ARRAY_AGG(skill) AS skills -- creating an array
-- !!! in this scenario we'll get a new RANDOM value every time we querty like skills[1], because we didn't specified the order of the values when creating an array
SELECT ARRAY_AGG(skill ORDER BY skill) AS skills -- the order is specified!

FROM skills
-- ARRAY_AGG = LIST, where ARRAY_AGG is actually an alias for the LIST function
)
SELECT
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill,
FROM 
    skills_array;


-- STRUCT
SELECT { skill: 'python', type: 'programming' } AS skill_struct;

WITH skill_struct AS
(
    SELECT 
        STRUCT_PACK -- creating a STRUCT
        (
            skill:= 'python',
            type := 'programming'
        ) AS s
)
SELECT
    s.skill,
    s.type
FROM skill_struct;


WITH skill_table AS
(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_larguage'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT
    STRUCT_PACK
    (
        skill := skills,
        type := types
    )
FROM skill_table;


-- Array of structs
SELECT
[
    { skill: 'python', type: 'programming' },
    { skill: 'sql', type: 'query_language' }
] AS skills_array_of_structs;


WITH skill_table AS
(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_larguage'
    UNION ALL
    SELECT 'r', 'programming'
),
skills_array_struct AS
(
    SELECT
        ARRAY_AGG
        (
            STRUCT_PACK
            (
                skill := skills,
                type := types
            )
        ) array_struct
    FROM skill_table
)
SELECT 
    array_struct [1].skill,
    array_struct [2].type,
    array_struct [3]
FROM skills_array_struct;


-- MAP / OBJECT / DICTIONARY
SELECT MAP {'skill' : 'python'}; -- MAP keys must be unique!

WITH skill_map AS
(
    SELECT MAP {'skill' : 'python', 'type': 'programming'} AS skill_type
)
SELECT
    skill_type['skill'],
    skill_type['type']
FROM
    skill_map;


-- JSON
SELECT
    '{"skill":"python", "type":"programming"}'::JSON AS skill_json; -- CAST is the most common method

SELECT
    TO_JSON('{"skill":"python", "type":"programming"}') AS skill_json; -- another method, but the output looks awkward

WITH raw_skill_json AS
(
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT 
    STRUCT_PACK
    (
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;


-- Arrays - Final Example
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table

CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM
    data_jobs.job_postings_fact AS jpf
LEFT JOIN 
    data_jobs.skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN 
    data_jobs.skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL; -- available in DuckDB!!! 
-- GROUP BY
--     jpf.job_id,
--     jpf.job_title_short,
--     jpf.salary_year_avg;

-- From the perspective of Data analyst, analyze the median salary per skill
WITH flat_skills AS
(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM 
        job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC;


-- Array of structs - Final Example
-- Build a flat skill & type table for co-workers to access job titles, salary info, and skills and type in one table

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG
    (
        STRUCT_PACK
        (
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM
    data_jobs.job_postings_fact AS jpf
LEFT JOIN 
    data_jobs.skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN 
    data_jobs.skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL; 

-- From the perspective of a Data analyst, analyze the median salary per type of skill

WITH flat_skills AS
(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type AS skill_type,
        UNNEST(skills_type).skill_name AS skill_name
    FROM 
        job_skills_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_type;