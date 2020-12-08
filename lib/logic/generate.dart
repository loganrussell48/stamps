import 'dart:math';

List<DateTime> generateTimeStamp(DateTime start, DateTime end, int quantity) {
  var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  print('start hour: ${start.hour}');
  print('end hour: ${end.hour}');
  var hours = [
    for (int i = start.hour; i < end.hour; i++) i.toString().padLeft(2, '0')
  ];
  var allMinutes = [
    for (int i = 0; i < 60; i++) i.toString().padLeft(2, '0')
  ];
  var minutes = {
    start.hour.toString().padLeft(2, '0'): [
      for (int i = start.minute; i < 60; i++) i.toString().padLeft(2, '0')
    ],
    end.hour.toString().padLeft(2, '0'): [
      for (int i = 0; i < end.minute; i++) i.toString().padLeft(2, '0')
    ]
  };
  var rand = Random();
  const yearsBaseline = 1900;
  var yearsRange = DateTime.now().year - yearsBaseline;
  var result = <DateTime>[];
  for (int i = 0; i < quantity; i++) {
    var randYear = rand.nextInt(yearsRange) + yearsBaseline;
    var randMonth = rand.nextInt(12);
    var month = randMonth.toString().padLeft(2, '0');
    var randDay = (rand.nextInt(daysInMonth[randMonth]) + 1);
    var day = randDay.toString().padLeft(2, '0');
    var randHour = hours[rand.nextInt(hours.length)];
    var hour = randHour.toString().padLeft(2, '0');
    var minList = (minutes[randHour] ?? allMinutes);
    var randMinute = minList[rand.nextInt(minList.length)];
    var minute = randMinute.toString().padLeft(2, '0');
    var randSecond = rand.nextInt(60);
    var second = randSecond.toString().padLeft(2, '0');
    var randMillis = rand.nextInt(1000);
    var millis = randMillis.toString().padLeft(3, '0');
    result.add(DateTime.parse(
        '$randYear-$month-${day} $hour:$minute:$second.${millis}'));
  }
  return result;
}