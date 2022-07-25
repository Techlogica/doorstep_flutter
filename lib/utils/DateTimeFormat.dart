// ignore_for_file: file_names, avoid_print

import 'package:intl/intl.dart';

class DateTimeFormat {
  parseServerDateTime(String input) {
    String output = "";
    if (input.isNotEmpty) {
      try {
        var inputformat = DateFormat('yyyy-mm-ddTHH:MM:SS');
        var newDate = inputformat.parse(input);

        var outputformat = DateFormat('dd-mm-yyyy HH:MM');
        output = outputformat.format(newDate);
      } on Exception catch (e) {
        print(e);
      }
    }
    return output;
  }
}
