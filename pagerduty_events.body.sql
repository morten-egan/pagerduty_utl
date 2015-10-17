create or replace package body pagerduty_events

as


begin

	dbms_application_info.set_client_info('pagerduty_events');
	dbms_session.set_identifier('pagerduty_events');

end pagerduty_events;
/