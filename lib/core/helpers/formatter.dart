import 'package:flutter/services.dart';
import 'package:sip_sales_clean/core/constant/special_char.dart';

class Formatter {
  static String removeSpaces(String text) {
    return text.trim();
  }

  static TextInputFormatter get normalFormatter {
    return FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z 0-9./@]*$'));
  }

  /// Allows alphanumeric characters, common symbols (./@:), and basic punctuation for general text input
  static FilteringTextInputFormatter allowCommonTextInput =
      FilteringTextInputFormatter.allow(
        RegExp(r'[a-zA-Z0-9./@\s:()%+-?]*'),
      );

  /// Converts a string to title case (first letter of each word capitalized, rest lowercase).
  /// Example: 'hELLO wOrLd' becomes 'Hello World'
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;

    // Split into words, trim whitespace, and filter out empty strings
    final words = text
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .toList();

    // Process each word
    final result = <String>[];
    for (final word in words) {
      if (word.isEmpty) continue;
      result.add(
        word[0].toUpperCase() +
            (word.length > 1 ? word.substring(1).toLowerCase() : ''),
      );
    }

    return result.join(' ');
  }

  /// Converts a string to title case (first letter of each word capitalized, rest lowercase except 'SIP').
  /// Example: 'SIP NANGKAAN' becomes 'SIP Nangkaan'
  static String toBranchShopName(String text) {
    // if (text.contains('SURYA INTI PUTRA')) {
    //   log('Contains surya inti putra');
    //   return text.toLowerCase().replaceAll(
    //     RegExp('surya inti putra', caseSensitive: false),
    //     'SIP',
    //   );
    // } else {
    //   return toTitleCase(text).replaceFirst('Sip', 'SIP');
    // }
    return toTitleCase(text).replaceFirst('Sip', 'SIP');
  }

  static String dateFormat(String tanggal) {
    String thn = tanggal.substring(0, 4);
    String bln = tanggal.substring(5, 7);
    String tgl = tanggal.substring(8, 10);
    return tanggal.replaceRange(0, 10, '$tgl-$bln-$thn');
  }

  static String dayFormat(String tanggal) {
    String tgl = tanggal.substring(8, 10);
    return tgl;
  }

  static String monthFormat(String tanggal) {
    String bln = tanggal.substring(5, 7);
    return bln;
  }

  static String yearFormat(String tanggal) {
    String thn = tanggal.substring(0, 4);
    return thn;
  }

  // ~:Change only first letter of a sentence to uppercase:~
  static String toFirstLetterUpperCase(String text) {
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // ~:Change certain characters to be formatted into the correct format:~
  // Example: 'Surya Inti Putra' to 'SIP'; 'Graha Rssm' to 'Graha RSSM'
  static String toCompanyAbbForm(String text) {
    if (text.isEmpty) return text;

    text = toTitleCase(text);

    if (text.contains('Surya Inti Putra')) {
      return text.replaceAll(
        RegExp('surya inti putra', caseSensitive: false),
        'SIP',
      );
    } else {
      // Split the text into words
      final words = text.split(' ');

      // Process each word
      final processedWords = words.map((word) {
        // Check if the word matches any special company name (case-insensitive)
        for (var company in SpecialCharacter.ltdCompany) {
          if (word.toLowerCase() == company.toLowerCase()) {
            return company; // Return the properly formatted company name
          }
        }
        return word; // Return the word as-is if no match
      }).toList();

      return processedWords.join(' ');
    }
  }
}
