import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


String formatLargeNumber(int number) {
  return number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match match) => "${match.group(1)} ",
      );
}

String formatDate(String dateString, String dateFormat) {
  try {
    DateTime dateTime = DateTime.parse(dateString);
    initializeDateFormatting('fr', null);
    DateFormat formatter = DateFormat(dateFormat, 'fr');
    return formatter.format(dateTime);
  } catch (e) {
    return "Date invalide";
  }
}
