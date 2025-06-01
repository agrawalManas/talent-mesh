import 'package:flutter/services.dart';

class CurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    int cursorPosition = newValue.selection.baseOffset;

    // Remove any non-numeric characters except decimal point
    text = text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Handle multiple decimal points - keep only the first one
    List<String> parts = text.split('.');
    if (parts.length > 2) {
      text = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    // If empty or just a decimal point, return as is
    if (text.isEmpty || text == '.') {
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    // Count digits before cursor position in the original input
    int digitsBeforeCursor = 0;
    for (int i = 0; i < cursorPosition && i < newValue.text.length; i++) {
      if (RegExp(r'[0-9.]').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    // Format as Indian currency
    String formattedText = _formatIndianCurrency(text);

    // Calculate new cursor position
    int newCursorPosition =
        _calculateCursorPosition(formattedText, digitsBeforeCursor);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  int _calculateCursorPosition(String formattedText, int digitsBeforeCursor) {
    int digitCount = 0;

    for (int i = 0; i < formattedText.length; i++) {
      if (RegExp(r'[0-9.]').hasMatch(formattedText[i])) {
        digitCount++;
        if (digitCount >= digitsBeforeCursor) {
          return i + 1;
        }
      }
    }

    return formattedText.length;
  }

  String _formatIndianCurrency(String number) {
    if (number.isEmpty || number == '.') return number;

    // Split into integer and decimal parts
    List<String> parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // If only decimal part exists (like ".5"), don't format
    if (integerPart.isEmpty) {
      return number;
    }

    // Format the integer part only if it has more than 3 digits
    String formattedInteger = _formatIntegerPart(integerPart);

    // Combine with decimal part if it exists
    if (decimalPart.isNotEmpty) {
      return '$formattedInteger.$decimalPart';
    } else if (parts.length > 1) {
      // User typed a decimal point but no decimal digits yet
      return '$formattedInteger.';
    } else {
      return formattedInteger;
    }
  }

  String _formatIntegerPart(String integerPart) {
    if (integerPart.isEmpty) return '';

    // Convert to integer to handle leading zeros
    int value = int.parse(integerPart);
    String valueStr = value.toString();

    if (valueStr.length <= 3) {
      return valueStr;
    }

    // Build the formatted string from right to left
    List<String> parts = [];

    // Take the last 3 digits
    parts.add(valueStr.substring(valueStr.length - 3));

    // Process remaining digits in groups of 2
    int remaining = valueStr.length - 3;
    while (remaining > 0) {
      int take = remaining >= 2 ? 2 : remaining;
      parts.add(valueStr.substring(remaining - take, remaining));
      remaining -= take;
    }

    // Reverse and join with commas
    return parts.reversed.join(',');
  }
}
