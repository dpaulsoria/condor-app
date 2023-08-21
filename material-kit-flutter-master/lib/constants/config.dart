String apiUrl = 'http://192.168.100.25:8080/';
String apiKeyMaps = "AIzaSyDu-8XIHqh0BRHXIB-wZfTAsz0k4l-0tMA";

var dateActual = DateTime.now();
var startDate =
    DateTime.utc(dateActual.year, dateActual.month, dateActual.day, 6, 0, 0);
var endDate =
    DateTime.utc(dateActual.year, dateActual.month, dateActual.day, 20, 0, 0);
const slotCalendarTime = Duration(minutes: 10);

const maxIntentsRequest = 30;
const slotRequestDrive = Duration(seconds: 5);
const slotRequestToDriver = Duration(seconds: 5);
var durationRefreshCareers = Duration(seconds: 20);
