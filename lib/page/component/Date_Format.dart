import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    initializeDateFormatting('id_ID', null);
    String formattedDate = DateFormat.yMMMMd('id_ID').format(date);
    return formattedDate;
  }
}