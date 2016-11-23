/**
 * Manages all of the client side alarm modification stuffs
 */
var DAYS_OF_WEEK = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];


/**
 * Returns a string indicating the issue if validation is unsuccessful,
 * or true if it was.
 */
function validateAlarm(){
    var alarmName = $('#form_alarm_name').val();
    var alarmDate = $('#form_alarm_date').val();
    var alarmTime = $('#form_alarm_time').val();

    if(alarmName.length === 0)
        return 'Alarm name is required';
    if(alarmDate.length === 0)
        return 'Alarm date is required';
    if(alarmTime.length === 0)
        return 'Alarm time is required';

    return true;
}

/**
 * Adds the alarm to the DB and displays it on the page.
 */
function addAlarm(data) {
    $.ajax({
        type: 'POST',
        url: '/add',
        data: data,
        success: function(resp){
            displayAllAlarms();
        },
        error: function(){
            var alert = $('<div/>', { "class":"alert alert-danger" });
            alert.append($('<strong>Server side error</strong>'));
            $('#form_alert_space').html(alert);
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
            // console.log(alarms);

            // For each alarm
            for(var i = 0; i < alarms.length; i++){
                var alarm = alarms[i];

                var newAlarm = $('<tr>');
                newAlarm.append($('<td>' + alarm.id +'</td>'));
                newAlarm.append($('<td>' + alarm.name + '</td>'));
                newAlarm.append($('<td>' + alarm.start_date.substring(0, 9) + '</td>')); // Date
                newAlarm.append($('<td>' + alarm.start_date.substring(11, 16) + '</td>')); // Time

                // All the week buttons
                var repeatButtons = $('<div/>', { "class":"btn-group", "data-toggle":"buttons", "id":alarm.id})

                for(var j = 0; j < 7; j++){
                    var day = DAYS_OF_WEEK[j];
                    var repeatButtonLabel = $('<label/>', {"class":"btn btn-xs btn-default"});

                    if(alarm.repeat.includes(day.toLowerCase())) {
                        repeatButtonLabel.addClass('active');
                        repeatButtonLabel.html('<input type="checkbox" autocomplete="off" checked/>' + day);
                    } else
                        repeatButtonLabel.html('<input type="checkbox" autocomplete="off" />' + day);

                    // TODO: Setup the change repeat buttons to work here

                    repeatButtons.append(repeatButtonLabel);
                }

                newAlarm.append($('<td/>').append(repeatButtons));

                // Whether or not the alarm is on
                var toggleOnOffButton = $('<button class="btn btn-xs"></button>');
                toggleOnOffButton.attr('id', 'toggle-' + alarm.id);


                if(alarm.is_on) {
                    toggleOnOffButton.addClass('btn-success');
                    toggleOnOffButton.html('ON');
                } else {
                    toggleOnOffButton.addClass('btn-default');
                    toggleOnOffButton.html('OFF');
                }

                toggleOnOffButton.click(function(evt){
                    var button = $(evt.target);
                    var id = button.attr('id');
                    toggleAlarm(id.substring(id.length - 1, id.length), button);
                });

                newAlarm.append($('<td/>').append(toggleOnOffButton));

                // The delete button
                newAlarm.append($('<td/>').append($('<button class="btn btn-danger btn-xs">DELETE</button>')));

                alarmTable.append(newAlarm);
            }
        },
        error: function(){}
    });
}

/**
 * Toggles on/off the alarm given.
 * @param id
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
                // TODO: Inform the user
            }
        },
        error: function(){
            // TODO: Something here
        }
    });
}

/**
 * TODO: This
 * @param id
 * @param day
 */
function addRepetition(id, day){

}

/**
 * TODO: This
 * @param id
 * @param day
 */
function removeRepetition(id, day){

}

/**
 * TODO This
 */
function deleteAlarm() {

}

$(document).ready(function(){
    // Display all of the alarms
    displayAllAlarms();

    // Setup the add alarm button
    $('#add_alarm').click(function(){
        var alert;
        var successful = validateAlarm();

        if (typeof successful !== 'string') {
            var alarmName = $('#form_alarm_name').val();
            var alarmDate = $('#form_alarm_date').val();
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
                date: alarmDate,
                time: alarmTime,
                repetitions: reps
            });

            alert = $('<div/>', { "class":"alert alert-success"});
            alert.append($('<strong>Alarm added</strong>'));

            $('#form_alarm_name').val('');
            $('#form_alarm_date').val('');
            $('#form_alarm_time').val('');

        } else {
            // Indicate to user what went wrong
            alert = $('<div/>', { "class":"alert alert-danger" });
            alert.append($('<strong>' + successful + '</strong>'));
        }

        $('#form_alert_space').html(alert);
    });
});