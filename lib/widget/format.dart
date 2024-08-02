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
}
