class ReturnPageConverter {
  static String convert(String page) {
    switch (page) {
      case 'menu':
        return '/menu';
      case 'profile':
        return '/profile';
      default:
        return '';
    }
  }
}
