SELECT LENGTH('SQL');

SELECT SUBSTRING('SQL',2,1);

SELECT REPLACE ('SQL', 'Q', '_');

SELECT REGEXP_REPLACE('data.nerd@gmail.com', '^.*(@)', '\1'); -- removes everything before '@'

SELECT NULLIF(10,10); -- RETURNS NULL!!!

SELECT NULLIF(10,20); -- RETURNS 10!

SELECT COALESCE(1,2,3); -- returns 1

SELECT COALESCE(NULL,2,3); -- returns 2