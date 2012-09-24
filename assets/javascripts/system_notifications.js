function observeSystemNotificationTime() {
	$("#system_notification_time").change(function() {
		handleUsersList($(this).val(), $("select##system_notification_projects").val());
	});
}

function observeSystemNotificationProjectList() {
	$("#system_notification_projects").change(function() {
		handleUsersList($("#system_notification_time").val(), $(this).val())
	});
}

function handleUsersList(time, projects) {
	new jQuery.ajax('users_since/', {
		data: {
			time: time,
			projects: projects
		},
		evalJSON: true
	});
}
