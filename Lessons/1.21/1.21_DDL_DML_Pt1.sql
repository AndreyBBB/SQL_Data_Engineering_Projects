create database if not exists jobs_mart;

show databases;

-- drop database if exists jobs_mart;

select *
from information_schema.schemata;

create schema if not exists jobs_mart.staging;

USE jobs_mart; -- works in several DBs - switch the default schema to the one named here

-- now, after USE, we don't need to specify the database
-- drop schema if exists staging;

CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

select *
from information_schema.tables
where table_catalog = 'jobs_mart';

-- drop table if exists staging.preferred_roles;

insert into staging.preferred_roles (role_id, role_name)
values
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer');

insert into staging.preferred_roles (role_id, role_name)
values
    (3, 'Software Engineer');

select *
from staging.preferred_roles;

alter table staging.preferred_roles
add column preferred_role BOOLEAN;

alter table staging.preferred_roles
DROP column preferred_role;

update staging.preferred_roles
set preferred_role = true
where role_id in (1,2);

update staging.preferred_roles
set preferred_role = false
where role_id =3;

alter table staging.preferred_roles
rename to priority_roles;

alter table staging.priority_roles
rename column preferred_role to priority_lvl;

select *
from staging.priority_roles;

alter table staging.priority_roles
alter column priority_lvl type integer;

update staging.priority_roles
set priority_lvl = 3
where role_id = 3;