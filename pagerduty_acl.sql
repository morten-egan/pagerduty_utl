begin
	dbms_network_acl_admin.create_acl (
		acl => 'pagerduty_acl.xml',
		description => 'ACL definition for Pagerduty.com access',
		principal => 'PAGERDUTY',
		is_grant => true, 
		privilege => 'connect',
		start_date => systimestamp,
		end_date => null
	);

	commit;

	dbms_network_acl_admin.add_privilege (
		acl => 'pagerduty_acl.xml',
		principal => 'PAGERDUTY',
		is_grant => true,
		privilege => 'resolve'
	);

	commit;

	dbms_network_acl_admin.assign_acl (
		acl => 'pagerduty_acl.xml',
		host => 'pagerduty.com',
		lower_port => 443,
		upper_port => null
	);

	commit;

end;
/