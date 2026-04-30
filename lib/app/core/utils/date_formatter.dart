import 'package:intl/intl.dart';

class AppDateFormatter {
  static String format(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatShortYear(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yy').format(date);
  }
}
