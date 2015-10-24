create or replace package body pagerduty_events

as

	function details_block
	return json
	
	as
	
		l_ret_val			json := json();
		l_version			varchar2(250);
		l_compatibility		varchar2(250);
	
	begin
	
		dbms_application_info.set_action('details_block');

		dbms_utility.db_version( l_version, l_compatibility );

		l_ret_val.put('os', dbms_utility.port_string);
		l_ret_val.put('language', 'PL/SQL ' || l_version);
		if substr(l_version,1,3) = '12.' then
			l_ret_val.put('environment', sys_context('USERENV', 'CON_NAME'));
		else
			l_ret_val.put('environment', sys_context('USERENV', 'DB_NAME'));
		end if;
		l_ret_val.put('Current schema', sys_context('USERENV', 'CURRENT_SCHEMA'));
		l_ret_val.put('Current user', sys_context('USERENV', 'CURRENT_USER'));
		l_ret_val.put('Database name', sys_context('USERENV', 'DB_NAME'));
	
		dbms_application_info.set_action(null);
	
		return l_ret_val;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end details_block;

	procedure trigger_event (
		description						in				varchar2
		, service_key					in				varchar2
		, incident_key					in				varchar2 default null
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('trigger_event');

		pagerduty.init_talk('will_override', 'POST');

		pagerduty.pagerduty_call_request.call_json.put('service_key', service_key);

		pagerduty.pagerduty_call_request.call_json.put('event_type', 'trigger');

		pagerduty.pagerduty_call_request.call_json.put('description', description);

		if incident_key is not null then
			pagerduty.pagerduty_call_request.call_json.put('incident_key', incident_key);
		end if;

		pagerduty.pagerduty_call_request.call_json.put('client','oracle - pagerduty_utl');
		pagerduty.pagerduty_call_request.call_json.put('client_url', 'http://www.codemonth.dk');

		pagerduty.pagerduty_call_request.call_json.put('details', details_block);

		pagerduty.talk('https://events.pagerduty.com/generic/2010-04-15/create_event.json');
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end trigger_event;

	procedure acknowledge_event (
		incident_key						in				varchar2
		, service_key						in				varchar2
		, description						in				varchar2 default null
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('acknowledge_events');

		pagerduty.init_talk('will_override', 'POST');

		pagerduty.pagerduty_call_request.call_json.put('service_key', service_key);

		pagerduty.pagerduty_call_request.call_json.put('event_type', 'acknowledge');

		pagerduty.pagerduty_call_request.call_json.put('incident_key', incident_key);

		if description is not null then
			pagerduty.pagerduty_call_request.call_json.put('description', description);
		end if;

		pagerduty.pagerduty_call_request.call_json.put('details', details_block);

		pagerduty.talk('https://events.pagerduty.com/generic/2010-04-15/create_event.json');
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end acknowledge_event;

	procedure resolve_event (
		incident_key						in				varchar2
		, service_key						in				varchar2
		, description						in				varchar2 default null
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('resolve_event');

		pagerduty.init_talk('will_override', 'POST');

		pagerduty.pagerduty_call_request.call_json.put('service_key', service_key);

		pagerduty.pagerduty_call_request.call_json.put('event_type', 'resolve');

		pagerduty.pagerduty_call_request.call_json.put('incident_key', incident_key);

		if description is not null then
			pagerduty.pagerduty_call_request.call_json.put('description', description);
		end if;

		pagerduty.pagerduty_call_request.call_json.put('details', details_block);

		pagerduty.talk('https://events.pagerduty.com/generic/2010-04-15/create_event.json');
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end resolve_event;

begin

	dbms_application_info.set_client_info('pagerduty_events');
	dbms_session.set_identifier('pagerduty_events');

end pagerduty_events;
/