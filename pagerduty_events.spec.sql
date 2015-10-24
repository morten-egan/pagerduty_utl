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
	* @param service_key The specific key for the service, where the incident is being raised.
	* @param incident_key A specifc incident key. If open incident already exists on ḱey, they will be combined.
	*/
	procedure trigger_event (
		description				in		varchar2
		, service_key			in		varchar2
		, incident_key			in		varchar2 default null
	);

	/** Acknowledge specific event with pagerduty
	* https://developer.pagerduty.com/documentation/integration/events/acknowledge
	* @author Morten Egan
	* @param incident_key The key of the incident we are acknowledging
	* @param service_key The specific key for the service where the incident belongs.
	* @param description A description of the acknowledgement, like work start time etc.
	*/
	procedure acknowledge_event (
		incident_key						in				varchar2
		, service_key						in				varchar2
		, description						in				varchar2 default null
	);

	/** Resolve pagerduty event
	* @author Morten Egan
	* @param incident_key The key of the incident we are resolving
	* @param service_key The specific key for the service where the incident belongs.
	* @param description A description of the resolvement.
	*/
	procedure resolve_event (
		incident_key						in				varchar2
		, service_key						in				varchar2
		, description						in				varchar2 default null
	);

end pagerduty_events;
/