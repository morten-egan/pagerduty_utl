create or replace package body pagerduty_incidents

as

	procedure get_incidents (
		since						in				varchar2 default null
		, until						in				varchar2 default null
		, date_range				in				varchar2 default null
		, fields					in				varchar2 default null
		, status					in				varchar2 default null
		, incident_key				in				varchar2 default null
		, service					in				varchar2 default null
		, teams						in				varchar2 default null
		, assigned_to_user			in				varchar2 default null
		, urgency					in				varchar2 default 'high,low'
		, timezone					in				varchar2 default 'UTC'
		, sortby					in				varchar2 default null
	)
	
	as

		query_string				varchar2(4000);
	
	begin
	
		dbms_application_info.set_action('get_incidents');

		if since is not null then
			query_string := query_string || '&since=' || utl_url.escape(since);
		end if;

		if until is not null then
			query_string := query_string || '&until=' || utl_url.escape(until);
		end if;

		if date_range is not null then
			query_string := query_string || '&date_range=' || utl_url.escape(date_range);
		end if;

		if fields is not null then
			query_string := query_string || '&fields=' || utl_url.escape(fields);
		end if;

		if status is not null then
			query_string := query_string || '&status=' || utl_url.escape(status);
		end if;

		if incident_key is not null then
			query_string := query_string || '&incident_key=' || utl_url.escape(incident_key);
		end if;

		if service is not null then
			query_string := query_string || '&service=' || utl_url.escape(service);
		end if;

		if teams is not null then
			query_string := query_string || '&teams=' || utl_url.escape(teams);
		end if;

		if assigned_to_user is not null then
			query_string := query_string || '&assigned_to_user=' || utl_url.escape(assigned_to_user);
		end if;

		if urgency is not null then
			query_string := query_string || '&urgency=' || utl_url.escape(urgency);
		end if;

		if timezone is not null then
			query_string := query_string || '&time_zone=' || utl_url.escape(timezone);
		end if;

		if sortby is not null then
			query_string := query_string || '&sort_by=' || utl_url.escape(sortby);
		end if;

		query_string := substr(query_string, 2);

		pagerduty.init_talk('incidents?' || query_string, 'GET');

		pagerduty.talk;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end get_incidents;

	procedure get_incident (
		incident_id						in				varchar2 default '1'
	)
	
	as

	begin
	
		dbms_application_info.set_action('get_incident');

		pagerduty.init_talk('incidents/' || incident_id, 'GET');

		pagerduty.talk;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end get_incident;

	function get_incidents_count (
		since						in				varchar2 default null
		, until						in				varchar2 default null
		, date_range				in				varchar2 default null
		, status					in				varchar2 default null
		, incident_key				in				varchar2 default null
		, service					in				varchar2 default null
		, teams						in				varchar2 default null
		, assigned_to_user			in				varchar2 default null
	)
	return number
	
	as

		l_ret_val						number;
	
	begin
	
		dbms_application_info.set_action('get_incident');

		pagerduty.init_talk('incidents/count', 'GET');

		pagerduty.talk;

		if l_api_result.result.exist('total') then
			l_ret_val := json_ext.get_number(l_api_result.result, 'total');
		else
			l_ret_val := 0;
		end if;
	
		dbms_application_info.set_action(null);

		return l_ret_val;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end get_incident;

begin

	dbms_application_info.set_client_info('pagerduty_incidents');
	dbms_session.set_identifier('pagerduty_incidents');

end pagerduty_incidents;
/