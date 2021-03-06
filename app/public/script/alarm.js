/**
 * Manages all of the client side alarm modification stuffs
 */
// TODO: The dates all have the last number cut off. Maybe fix how the dates appear

var DAYS_OF_WEEK = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

function showAlert(space, message, alertTypeClass){
    var alert = $('<div/>', { "class":"alert"});
    alert.addClass(alertTypeClass);
    alert.html('<strong>' + message + '</strong>');
    space.html(alert);
}

/**
 * Returns a string indicating the issue if validation is unsuccessful,
 * or true if it was.
 */
function validateAlarm(){
    var alarmName = $('#form_alarm_name').val();
    var alarmTime = $('#form_alarm_time').val();

    if(alarmName.length === 0)
        return 'Alarm name is required';
    if(alarmTime.length === 0)
        return 'Alarm time is required';

    var days = $('#form_alarm_repeat').find('label');
    var flag = false;
    for (var i in ['0', '1', '2', '3', '4', '5', '6']) {
        var day = $(days[i]);
        if (day.hasClass('active')){
            flag = true;
            break;
        }
    }

    if(!flag)
        return 'You must select at least one day for it to repeat';

    return true;
}

/**
 * Adds the alarm to the DB and displays it on the page.
 */
function addAlarm(data) {
    $.ajax({
        type: 'POST',
        url: '/alarm',
        data: data,
        success: function(resp){
            resp = JSON.parse(resp);

            if(resp.successful){
                displayAllAlarms();
                $('#form_alarm_name').val('');
                $('#form_alarm_time').val('');
                showAlert($('#form_alert_space'), 'Alarm added.', 'alert-success')
            } else {

            }
        },
        error: function(){
            showAlert($('#form_alert_space'), 'A server-side error occurred.', 'alert-danger');
        }
    });
}

/**
 * Displays all of the alarms in the proper place
 */
function displayAllAlarms(){
    var alarmTable = $('#alarm_table');
    alarmTable.html('');

    $.ajax({
        type: 'GET',
        url: '/alarms',
        success: function(resp){
            // Let's get all of the alarms
            var alarms = JSON.parse(resp).data.alarms;
            console.log(JSON.parse(resp).data.alarms);

            // For each alarm
            for(var i = 0; i < alarms.length; i++){
                var alarm = alarms[i];
                alarm.days = JSON.parse(alarm.days);

                console.log(alarm.alarm_time);

                var newAlarm = $('<tr id=alarm_' + alarm.id + '>');
                newAlarm.append($('<td>' + alarm.id +'</td>'));
                newAlarm.append($('<td>' + alarm.name + '</td>'));
                newAlarm.append($('<td>' + alarm.alarm_time.substring(11, 16) + '</td>'))

                // All the repeat buttons
                var repeatButtons = $('<div/>', { "class":"btn-group", "data-toggle":"buttons", "id":alarm.id})
                for(var j = 0; j < 7; j++){
                    var day = DAYS_OF_WEEK[j];
                    var repeatButtonLabel = $('<label/>', {"class":"btn btn-xs btn-default"});

                    if(alarm.days.includes(day)) {
                        repeatButtonLabel.addClass('active');
                        repeatButtonLabel.html('<input type="checkbox" autocomplete="off" checked>' + day + '</input>');
                    } else
                        repeatButtonLabel.html('<input type="checkbox" autocomplete="off">' + day + '</input>');

                    repeatButtonLabel.click(function() {
                        // This is super ugly, but I needed a way to get the ID of this alarm and send it back to the server
                        var alarmId = $(this).parent().parent().parent().attr('id').replace('alarm_', '');
                        toggleRepetition($(this).parent().parent().parent().attr('id').replace('alarm_', ''), this.innerText);
                    });

                    repeatButtons.append(repeatButtonLabel);
                }

                newAlarm.append($('<td/>').append(repeatButtons));

                // Whether or not the alarm is on
                var toggleOnOffButton = $('<button class="btn btn-xs"></button>');
                toggleOnOffButton.attr('id', 'toggle-' + alarm.id);

                if(alarm.enabled) {
                    toggleOnOffButton.addClass('btn-success');
                    toggleOnOffButton.html('ON');
                } else {
                    toggleOnOffButton.addClass('btn-default');
                    toggleOnOffButton.html('OFF');
                }

                toggleOnOffButton.click(function(evt){
                    var button = $(evt.target);
                    var id = button.attr('id');
                    toggleAlarm(parseInt(id.match(/[0-9]+/g)), button);
                });

                newAlarm.append($('<td/>').append(toggleOnOffButton));

                // The delete button
                var deleteButton = $('<button class="btn btn-danger btn-xs">DELETE</button>');
                deleteButton.click(function(){
                    // TODO: Fix this so that it does what the repeat button label does
                    deleteAlarm(alarm.id);
                });
                newAlarm.append($('<td/>').append(deleteButton));

                alarmTable.append(newAlarm);
            }
        },
        error: function(){
            showAlert($('#list_alert_space'), 'A server-side error occurred when trying to get the list of alarms.', 'alert-danger');
        }
    });
}

/**
 * Toggles on/off the alarm given.
 * @param id
 * @param button
 */
function toggleAlarm(id, button){
    $.ajax({
        type: 'PUT',
        url: '/toggle',
        data: { id:id },
        success: function(resp){
            resp = JSON.parse(resp);
            if(resp.successful){
                if(button.hasClass('btn-success')){
                    button.removeClass('btn-success');
                    button.addClass('btn-default');
                    button.html('OFF');
                } else {
                    button.removeClass('btn-default');
                    button.addClass('btn-success');
                    button.html('ON');
                }
            } else {
                showAlert($('#list_alert_space'), resp.message, 'alert-danger');
            }
        },
        error: function(){
            showAlert($('#list_alert_space'), 'A server-side error occurred.', 'alert-danger')
        }
    });
}

/**
 * Toggle the alarm's repetition on a given day.
 *
 * @param id
 * @param day
 */
function toggleRepetition(id, day){
    $.ajax({
        type: 'PUT',
        url: '/alarm',
        data: { id:id, day:day},
        success: function(resp){
            resp = JSON.parse(resp);

            if(resp.successful){
            } else {
                showAlert($('#list_alert_space'), resp.message, 'alert-danger');
            }
        },
        error: function(){

        }
    });
}
/**
 * Deletes the alarm matching the id provided.
 *
 * @param id
 */
function deleteAlarm(id) {
    $.ajax({
        type: 'DELETE',
        url: '/alarm',
        data: { id:id },
        success: function(resp){
            resp = JSON.parse(resp);

            if(resp.successful){
                displayAllAlarms();
                showAlert($('#list_alert_space'), 'Alarm deleted.', 'alert-success')
            } else {
                showAlert($('#list_alert_space'), resp.message, 'alert-danger');
            }
        },
        error: function(){
            showAlert($('#list_alert_space'), 'A server-side error occurred.', 'alert-danger')
        }
    });
}

$(document).ready(function(){
    // Display all of the alarms
    displayAllAlarms();

    // Setup the add alarm button
    $('#add_alarm').click(function(){
        var successful = validateAlarm();

        if (typeof successful !== 'string') {
            var alarmName = $('#form_alarm_name').val();
            var alarmTime = $('#form_alarm_time').val();
            var reps = [];

            var days = $('#form_alarm_repeat').find('label');
            for (var i in ['0', '1', '2', '3', '4', '5', '6']) {
                var day = $(days[i]);
                if (day.hasClass('active'))
                    reps.push(day[0].innerText);

                day.removeClass('active');
            }

            addAlarm({
                name: alarmName,
                time: alarmTime,
                days: reps
            });

        } else {
            // Indicate to user what went wrong
            showAlert($('#form_alert_space'), successful, 'alert-danger');
        }
    });
});