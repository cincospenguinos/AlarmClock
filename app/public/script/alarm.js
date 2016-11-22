/**
 * Manages all of the client side alarm modification stuffs
 */

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
 * TODO: This
 */
function addAlarm(data) {

}

/**
 * TODO This
 */
function toggleAlarm() {

}

/**
 * TODO This
 */
function deleteAlarm() {

}

$(document).ready(function(){

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
            }

            // TODO: Send the information

            alert = $('<div/>', { "class":"alert alert-success"});
            alert.append($('<strong>Alarm added</strong>'));
        } else {
            // Indicate to user what went wrong
            console.log(successful);
            alert = $('<div/>', { "class":"alert alert-danger" });
            alert.append($('<strong>' + successful + '</strong>'));
        }

        $('#form_alert_space').html(alert);
    });

});