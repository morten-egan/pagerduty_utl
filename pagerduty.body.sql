create or replace package body pagerduty_utl

as


begin

	dbms_application_info.set_client_info('pagerduty_utl');
	dbms_session.set_identifier('pagerduty_utl');

end pagerduty_utl;
/