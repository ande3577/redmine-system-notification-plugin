function observeSystemNotificationTime() {
	$("#system_notification_time").change(function() {
		handleUsersList($(this).val(), $("#system_notification_projects").val(), $("#system_notification_roles").val());
	});
	handleUsersList($("#system_notification_time").val(), $("#system_notification_projects").val(), $("#system_notification_roles").val());
}

function observeSystemNotificationProjectList() {
	$("#system_notification_projects").change(function() {
		handleUsersList($("#system_notification_time").val(), $(this).val(), $("#system_notification_roles").val());
	});
}

function observerSystemNotificationRolesList() {
	$("#system_notification_roles").change(function() {
		handleUsersList($("#system_notification_time").val(), $("#system_notification_projects").val(), $(this).val());
	});
}

function handleUsersList(time, projects, roles) {
	new jQuery.ajax('users_since/', {
		data: {
			time: time,
			projects: projects,
			roles: roles
		},
      success: function(data, textStatus, jqXHR) {
    	  $('#user_list').html(data);
        },
		evalJSON: true
	});
}
