class DateUtils {
  static parseDate(String date) {
    String formattedString = "";
    if (date.contains('January')) {
      formattedString = date.replaceFirst('January', '01');
    }
    if (date.contains('February')) {
      formattedString = date.replaceFirst('February', '02');
    }
    if (date.contains('March')) {
      formattedString = date.replaceFirst('March', '03');
    }
    if (date.contains('April')) {
      formattedString = date.replaceFirst('April', '04');
    }
    if (date.contains('May')) {
      formattedString = date.replaceFirst('May', '05');
    }
    if (date.contains('June')) {
      formattedString = date.replaceFirst('June', '06');
    }
    if (date.contains('July')) {
      formattedString = date.replaceFirst('July', '07');
    }
    if (date.contains('August')) {
      formattedString = date.replaceFirst('August', '08');
    }
    if (date.contains('September')) {
      formattedString = date.replaceFirst('September', '09');
    }
    if (date.contains('October')) {
      formattedString = date.replaceFirst('October', '10');
    }
    if (date.contains('November')) {
      formattedString = date.replaceFirst('November', '11');
    }
    if (date.contains('December')) {
      formattedString = date.replaceFirst('December', '12');
    }
    var formattedStringList = formattedString.split("-");
    formattedStringList = formattedStringList.reversed.toList();
    formattedString = formattedStringList.join("-");
    return formattedString;
  }
}