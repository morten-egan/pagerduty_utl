create or replace package pagerduty_alerts

as

	/** This is the plsql wrapper for the pagerduty Alerts API
	* https://developer.pagerduty.com/documentation/rest/alerts/
	* @author Morten Egan
	* @version 0.0.1
	* @project PAGERDUTY_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	/** Get a list of all alerts
	* @author Morten Egan
	* @param since The start of the date range you want to list alerts from. Format (ISO 8601): YYYY-MM-DDTHH24:MI(+-)HH
	* @param until The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
	* @param filter [type]You can filter the alerts, by the type: SMS, Email, Phone or Push
	* @param timezone Time zone in which dates in the result will be rendered. Defaults to account time zone.
	*/
	procedure get_alerts (
		since						in				varchar2 default to_char(add_months(sysdate,-3), 'YYYY-MM-DD')
		, until 					in				varchar2 default to_char(sysdate, 'YYYY-MM-DD')
		, filter					in				varchar2 default null
		, timezone					in				varchar2 default null
	);

end pagerduty_alerts;
/