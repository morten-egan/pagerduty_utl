create or replace package pagerduty_events

as

	/** This package integrates into the Event API
	* https://developer.pagerduty.com/documentation/integration/events/
	* @author Morten Egan
	* @version 0.0.1
	* @project PAGERDUTY_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	/** Trigger an event with pagerduty
	* https://developer.pagerduty.com/documentation/integration/events/trigger
	* @author Morten Egan
	* @param description A description of the event that is being triggered.
	*/
	procedure trigger_event (
		description						in				varchar2
		, incident_key					in				varchar2 default null
		, service_key					in				varchar2 default null
	);

end pagerduty_events;
/