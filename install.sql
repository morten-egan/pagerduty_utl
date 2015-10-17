@@user.sql
@@pagerduty_acl.sql

connect pagerduty/pagerduty

@@pljson/install.sql

REM Installing package specs
@@pagerduty.spec.sql

REM Installing package bodies
@@pagerduty.body.sql
