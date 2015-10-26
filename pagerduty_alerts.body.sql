create or replace package body pagerduty_alerts

as

	procedure get_alerts (
		since						in				varchar2 default to_char(add_months(sysdate,-3), 'YYYY-MM-DD')
		, until 					in				varchar2 default to_char(sysdate, 'YYYY-MM-DD')
		, filter					in				varchar2 default null
		, timezone					in				varchar2 default null
	)
	
	as

		full_alerts_query			varchar2(1024) := 'alerts?since=' || since || '&until=' || until;
	
	begin
	
		dbms_application_info.set_action('get_alerts');

		if filter is not null and timezone is not null then
			full_alerts_query := full_alerts_query || '&filter[type]=' || filter || '&time_zone=' || timezone;
		elsif filter is not null and timezone is null then
			full_alerts_query := full_alerts_query || '&filter[type]=' || filter;
		elsif filter is null and timezone is not null then
			full_alerts_query := full_alerts_query || '&time_zone=' || timezone;
		end if;

		pagerduty.init_talk(full_alerts_query, 'GET');

		pagerduty.talk;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end get_alerts;

begin

	dbms_application_info.set_client_info('pagerduty_alerts');
	dbms_session.set_identifier('pagerduty_alerts');

end pagerduty_alerts;
/