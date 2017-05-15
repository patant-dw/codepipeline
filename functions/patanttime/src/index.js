var time = require('time');
exports.handler = (event, context, callback) => {
    var currentTime = new time.Date(); 
    currentTime.setTimezone("Europe/Stockholm");
    callback(null, {
        statusCode: '200',
        body: 'The time in Stockholm is: ' + currentTime.toString(),
    });
};
