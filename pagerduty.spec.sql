create or replace package pagerduty

as

	/** PLSQL Integration package to the Pagerduty.com API
	* https://developer.pagerduty.com/documentation/rest
	* @author Morten Egan
	* @version 0.0.1
	* @project PAGERDUTY_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	-- Types and globals
	type session_settings is record (
		transport_protocol			varchar2(4000)
		, pagerduty_host			varchar2(4000)
		, pagerduty_host_port		varchar2(4000)
		, pagerduty_api_name		varchar2(4000)
		, pagerduty_api_version		varchar2(4000)
		, wallet_location			varchar2(4000)
		, wallet_password			varchar2(4000)
		, pagerduty_project_id 		varchar2(4000)
		, pagerduty_project_key		varchar2(4000)
		, pagerduty_api_key			varchar2(4000)
	);
	pagerduty_session				session_settings;

	type call_request is record (
		call_endpoint				varchar2(4000)
		, call_method				varchar2(100)
		, call_json					json
	);
	pagerduty_call_request			call_request;

	type call_result is record (
		result_type					varchar2(200)
		, result 					json
		, result_list				json_list
	);
	pagerduty_response_result		call_result;

	pagerduty_api_raw_result		clob;
	pagerduty_call_status_code		pls_integer;
	pagerduty_call_status_reason	varchar2(256);

	type text_text_arr is table of varchar2(4000) index by varchar2(250);
	pagerduty_response_headers		text_text_arr;

	/** This procedure will setup the pagerduty session
	* @author Morten Egan
	* @param transport_protocol The protocol to use for communication
	*/
	procedure session_setup (
		transport_protocol			in				varchar2
		, pagerduty_host			in				varchar2
		, pagerduty_host_port		in				varchar2
		, pagerduty_api_name		in				varchar2
		, pagerduty_api_version		in				varchar2
		, wallet_location			in				varchar2
		, wallet_password			in				varchar2
		, pagerduty_project_id 		in				varchar2
		, pagerduty_project_key		in				varchar2
		, pagerduty_api_key			in				varchar2
	);

	/** Initiate the endpoint talk
	* @author Morten Egan
	* @param endpoint The endpoint destination
	* @param endpoint_method GET/POST/DELETE/UPDATE http method
	*/
	procedure init_talk (
		endpoint					in				varchar2
		, endpoint_method			in				varchar2 default 'GET'
	);

	/** This procedure does the actual endpoint invocation, with all the settings
	* @author Morten Egan
	*/
	procedure talk;

end pagerduty;
/