create or replace package body pagerduty

as

	procedure session_setup (
		transport_protocol					in				varchar2
		, pagerduty_host					in				varchar2
		, pagerduty_host_port				in				varchar2
		, pagerduty_api_name				in				varchar2
		, pagerduty_api_version				in				varchar2
		, wallet_location					in				varchar2
		, wallet_password					in				varchar2
		, pagerduty_project_id 				in				varchar2
		, pagerduty_project_key				in				varchar2
		, pagerduty_api_key					in				varchar2
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('session_setup');

		if transport_protocol is not null then
			-- from 12c we need to lower the protocol name
			pagerduty_session.transport_protocol := lower(transport_protocol);
		end if;

		if pagerduty_host is not null then
			pagerduty_session.pagerduty_host := pagerduty_host;
		end if;

		if pagerduty_host_port is not null then
			pagerduty_session.pagerduty_host_port := pagerduty_host_port;
		end if;

		if pagerduty_api_name is not null then
			pagerduty_session.pagerduty_api_name := pagerduty_api_name;
		end if;

		if pagerduty_api_version is not null then
			pagerduty_session.pagerduty_api_version := pagerduty_api_version;
		end if;

		if wallet_location is not null then
			pagerduty_session.wallet_location := wallet_location;
		end if;

		if wallet_password is not null then
			pagerduty_session.wallet_password := wallet_password;
		end if;

		if pagerduty_project_id is not null then
			pagerduty_session.pagerduty_project_id := pagerduty_project_id;
		end if;

		if pagerduty_project_key is not null then
			pagerduty_session.pagerduty_project_key := pagerduty_project_key;
		end if;

		if pagerduty_api_key is not null then
			pagerduty_session.pagerduty_api_key := pagerduty_api_key;
		end if;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end session_setup;

	procedure parse_pagerduty_result 
	
	as
	
	begin
	
		dbms_application_info.set_action('parse_pagerduty_result');

		if substr(pagerduty_api_raw_result, 1 , 1) = '[' then
			pagerduty_response_result.result_type := 'JSON_LIST';
			pagerduty_response_result.result_list := json_list(pagerduty_api_raw_result);
		else
			pagerduty_response_result.result_type := 'JSON';
			pagerduty_response_result.result := json(pagerduty_api_raw_result);
		end if;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end parse_pagerduty_result;

	procedure init_talk (
		endpoint					in				varchar2
		, endpoint_method			in				varchar2 default 'GET'
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('init_talk');

		pagerduty_call_request.call_endpoint := endpoint;
		pagerduty_call_request.call_method := endpoint_method;
		pagerduty_call_request.call_json := json();
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end init_talk;

	procedure talk (
		endpoint_override							varchar2
	)
	
	as

		pagerduty_request				utl_http.req;
		pagerduty_response				utl_http.resp;
		pagerduty_result_piece			varchar2(32000);

		pagerduty_header_name			varchar2(4000);
		pagerduty_header_value			varchar2(4000);

		session_setup_error				exception;
		pragma exception_init(session_setup_error, -20001);
	
	begin
	
		dbms_application_info.set_action('talk');

		-- Always reset result
		pagerduty.pagerduty_api_raw_result := null;

		-- Extended error checking
		utl_http.set_response_error_check(
			enable => true
		);
		utl_http.set_detailed_excp_support(
			enable => true
		);

		if pagerduty_session.transport_protocol is not null then
			if pagerduty_session.transport_protocol = 'https' then
				utl_http.set_wallet(
					pagerduty_session.wallet_location
					, pagerduty_session.wallet_password
				);
			end if;
		else
			raise_application_error(-20001, 'Transport protocol is not defined');
		end if;

		utl_http.set_follow_redirect (
			max_redirects => 1
		);

		if endpoint_override is not null then
			dbms_output.put_line(endpoint_override);
			pagerduty_request := utl_http.begin_request(
				url => endpoint_override
				, method => pagerduty_call_request.call_method
			);
		else
			if pagerduty_session.pagerduty_host is not null and pagerduty_session.pagerduty_host_port is not null and pagerduty_session.pagerduty_api_name is not null and pagerduty_session.pagerduty_api_version is not null then
				pagerduty_request := utl_http.begin_request(
					url => pagerduty_session.transport_protocol || '://' || pagerduty_session.pagerduty_host || ':' || pagerduty_session.pagerduty_host_port || '/' || pagerduty_session.pagerduty_api_name || '/' || pagerduty_session.pagerduty_api_version || '/' || pagerduty_call_request.call_endpoint
					, method => pagerduty_call_request.call_method
				);
				dbms_output.put_line(pagerduty_session.transport_protocol || '://' || pagerduty_session.pagerduty_host || ':' || pagerduty_session.pagerduty_host_port || '/' || pagerduty_session.pagerduty_api_name || '/' || pagerduty_session.pagerduty_api_version || '/' || pagerduty_call_request.call_endpoint);
			else
				raise_application_error(-20001, 'pagerduty site parameters invalid');
			end if;
		end if;

		utl_http.set_header(
			r => pagerduty_request
			, name => 'User-Agent'
			, value => 'PAGERDUTY_UTL - PLSQL Ninja'
		);

		-- Pagerduty authentication header
		if pagerduty_session.pagerduty_api_key is not null then
			utl_http.set_header(
				r => pagerduty_request
				, name => 'Authorization'
				, value => 'Token token=' || pagerduty_session.pagerduty_api_key
			);
		end if;

		-- Method specific headers
		if (length(pagerduty_call_request.call_json.to_char) > 4) then
			utl_http.set_header(
				r => pagerduty_request
				, name => 'Content-Type'
				, value => 'application/json'
			);
			utl_http.set_header(
				r => pagerduty_request
				, name => 'Content-Length'
				, value => length(pagerduty_call_request.call_json.to_char)
			);
			-- Write the content
			utl_http.write_text (
				r => pagerduty_request
				, data => pagerduty_call_request.call_json.to_char
			);
		end if;

		pagerduty_response := utl_http.get_response (
			r => pagerduty_request
		);

		-- Should handle exceptions here
		pagerduty_call_status_code := pagerduty_response.status_code;
		pagerduty_call_status_reason := pagerduty_response.reason_phrase;

		-- Load header data before reading body
		for i in 1..utl_http.get_header_count(r => pagerduty_response) loop
			utl_http.get_header(
				r => pagerduty_response
				, n => i
				, name => pagerduty_header_name
				, value => pagerduty_header_value
			);
			pagerduty_response_headers(pagerduty_header_name) := pagerduty_header_value;
		end loop;

		-- Collect response and put into api_result
		begin
			loop
				utl_http.read_text (
					r => pagerduty_response
					, data => pagerduty_result_piece
				);
				pagerduty_api_raw_result := pagerduty_api_raw_result || pagerduty_result_piece;
			end loop;

			exception
				when utl_http.end_of_body then
					null;
				when others then
					raise;
		end;

		utl_http.end_response(
			r => pagerduty_response
		);

		-- Parse result into json
		parse_pagerduty_result;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end talk;

begin

	dbms_application_info.set_client_info('pagerduty_utl');
	dbms_session.set_identifier('pagerduty_utl');

end pagerduty;
/