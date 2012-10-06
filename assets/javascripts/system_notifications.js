function observeSystemNotificationTime() {
	$("#system_notification_time").change(function() {
		handleUsersList($(this).val(), $("#system_notification_projects").val());
	});
	handleUsersList($("#system_notification_time").val(), $("#system_notification_projects").val());
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
      success: function(data, textStatus, jqXHR) {
    	  $('#user_list').html(data);
        },
		evalJSON: true
	});
}
