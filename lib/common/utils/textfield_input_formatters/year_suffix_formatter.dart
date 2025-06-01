import 'package:flutter/services.dart';

class YearsSuffixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // Remove any non-numeric characters except decimal point
    text = text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Add "years" suffix if there's any number
    if (text.isNotEmpty && text != '.') {
      text = '$text years';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: text.isEmpty
            ? 0
            : text.length - 6, // Position cursor before "years"
      ),
    );
  }
}
