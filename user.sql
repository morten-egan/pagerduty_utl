create user pagerduty identified by pagerduty
default tablespace users
temporary tablespace temp
quota unlimited on users;

grant create session to pagerduty;
grant create table to pagerduty;
grant create procedure to pagerduty;
grant execute on utl_http to pagerduty;
grant create type to pagerduty;