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

bool containsIgnoringCaseAndAccents(String str1, String str2) {
  String normalizedStr1 = removeAccents(str1.toLowerCase());
  String normalizedStr2 = removeAccents(str2.toLowerCase());

  return normalizedStr1.contains(normalizedStr2);
}

String removeAccents(String input) {
  const diacritics = 'ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝàáâãäåçèéêëìíîïðñòóôõöøùúûüýÿ';
  const replacements = 'AAAAAAACEEEEIIIIDNOOOOOOUUUUYaaaaaaaceeeeiiiidnoooooouuuuyy';

  var output = input.split('').map((char) {
    var index = diacritics.indexOf(char);
    return index != -1 ? replacements[index] : char;
  }).join('');

  return output;
}
