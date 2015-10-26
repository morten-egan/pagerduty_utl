create or replace package pagerduty_incidents

as

	/** This is the plsql wrapper for the pagerduty Incidents API
	* https://developer.pagerduty.com/documentation/rest/incidents
	* @author Morten Egan
	* @version 0.0.1
	* @project PAGERDUTY_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	/** List incidents reported.
	* @author Morten Egan
	* @param since The start of the date range you want to list alerts from. Format (ISO 8601): YYYY-MM-DDTHH24:MI(+-)HH.
	* @param until The end of the date range over which you want to search.
	* @param date_range When set to all, the since and until parameters and defaults are ignored. Use this to get all incidents since the account was created.
	* @param fields Used to restrict the properties of each incident returned to a set of pre-defined fields. If omitted, returned incidents have the majority of fields present.
	* @param status Returns only the incidents currently in the passed status(es). Valid status options are triggered, acknowledged, and resolved. More status codes may be introduced in the future. Separate multiple statuses with a comma.
	* @param incident_key Returns only the incidents with the passed de-duplication key.
	* @param service Returns only the incidents associated with the passed service(s). This expects one or more service IDs. Separate multiple ids with a comma.
	* @param teams A comma-separated list of team IDs, specifying teams whose maintenance windows will be returned.
	* @param assigned_to_user Returns only the incidents currently assigned to the passed user(s). This expects one or more user IDs. Separate multiple ids with a comma.
	* @param urgency Comma-separated list of the urgencies of the incidents to be returned. Defaults to high,low.
	* @param timezone Time zone in which dates in the result will be rendered. Defaults to UTC.
	* @param sortby Example: to sort incidents by urgency (showing low-urgency incidents first) and secondarily sort by incident_number, include the query parameter: ?sort_by=urgency:asc,incident_number:desc
	*/
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
	);

	/** Get specific incident
	* @author Morten Egan
	* @param incident_id The id of the incident (Either incident id or incident number)
	*/
	procedure get_incident (
		incident_id						in				varchar2 default '1'
	);

	/** Get only incident counts of specific queries.
	* @author Morten Egan
	* @param since since The start of the date range you want to list alerts from. Format (ISO 8601): YYYY-MM-DDTHH24:MI(+-)HH.
	* @param until The end of the date range over which you want to search.
	* @param date_range When set to all, the since and until parameters and defaults are ignored. Use this to get all incidents since the account was created.
	* @param status Returns only the incidents currently in the passed status(es). Valid status options are triggered, acknowledged, and resolved. More status codes may be introduced in the future. Separate multiple statuses with a comma.
	* @param incident_key Returns only the incidents with the passed de-duplication key.
	* @param service Returns only the incidents associated with the passed service(s). This expects one or more service IDs. Separate multiple ids with a comma.
	* @param teams A comma-separated list of team IDs, specifying teams whose maintenance windows will be returned.
	* @param assigned_to_user Returns only the incidents currently assigned to the passed user(s). This expects one or more user IDs. Separate multiple ids with a comma.
	* @return The count of the specific query
	*/
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
	return number;

end pagerduty_incidents;
/