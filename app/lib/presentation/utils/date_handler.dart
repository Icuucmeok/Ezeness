

class DateHandler {
  final String date;


  DateHandler(this.date);

  String getDate() {
    return date.toString().split(' ').first;
  }

  String getFullDate() {
    return date.toString().split(' ').first+" \n "+date.split(' ').last;
  }

  String getTime() {
    var time=date.toString().split(' ').last;
    return time.split(".").first.substring(0,5);
  }
}

