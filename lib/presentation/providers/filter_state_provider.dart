import 'package:flutter/foundation.dart';

class FilterStateProvider extends ChangeNotifier {
  String _selectedDate = DateTime.now().toIso8601String().substring(0, 10);
  String _selectedLeasing = '';
  String _selectedCategory = '';

  ValueNotifier<String> get selectedDate => ValueNotifier(_selectedDate);
  ValueNotifier<String> get selectedLeasing => ValueNotifier(_selectedLeasing);
  ValueNotifier<String> get selectedCategory =>
      ValueNotifier(_selectedCategory);

  void setSelectedDate(String value) {
    _selectedDate = value;
    notifyListeners();
  }

  void setSelectedLeasing(String value) {
    _selectedLeasing = value;
    notifyListeners();
  }

  void setSelectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void clearFilters() {
    _selectedDate = '';
    _selectedLeasing = '';
    _selectedCategory = '';
    notifyListeners();
  }
}
