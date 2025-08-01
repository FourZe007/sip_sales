class Format {
  static String tanggalFormat(String tanggal) {
    String thn = tanggal.substring(0, 4);
    String bln = tanggal.substring(5, 7);
    String tgl = tanggal.substring(8, 10);
    return tanggal.replaceRange(0, 10, '$tgl-$bln-$thn');
  }

  static String dateFormat(String tanggal) {
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
