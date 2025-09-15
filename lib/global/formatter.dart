class Formatter {
  /// Converts a string to title case (first letter of each word capitalized, rest lowercase).
  /// Example: 'hELLO wOrLd' becomes 'Hello World'
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;

    // Split into words, trim whitespace, and filter out empty strings
    final words =
        text.split(' ').where((word) => word.trim().isNotEmpty).toList();

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
}
