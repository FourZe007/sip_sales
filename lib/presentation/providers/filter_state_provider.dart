import 'package:flutter/foundation.dart';

class FilterStateProvider extends ChangeNotifier {
  final ValueNotifier<String> _selectedDate = ValueNotifier(
    DateTime.now().toIso8601String().substring(0, 10),
  );
  final ValueNotifier<String> _selectedDealer = ValueNotifier('');
  final ValueNotifier<String> _selectedLeasing = ValueNotifier('');
  final ValueNotifier<String> _selectedCategory = ValueNotifier('');

  ValueNotifier<String> get selectedDate => _selectedDate;
  ValueNotifier<String> get selectedDealer => _selectedDealer;
  ValueNotifier<String> get selectedLeasing => _selectedLeasing;
  ValueNotifier<String> get selectedCategory => _selectedCategory;

  void setSelectedDate(String value) {
    _selectedDate.value = value;
    notifyListeners();
  }

  void setSelectedDealer(String value) {
    _selectedDealer.value = value;
    notifyListeners();
  }

  void setSelectedLeasing(String value) {
    _selectedLeasing.value = value;
    notifyListeners();
  }

  void setSelectedCategory(String value) {
    _selectedCategory.value = value;
    notifyListeners();
  }

  void clearFilters() {
    _selectedDate.value = '';
    _selectedDealer.value = '';
    _selectedLeasing.value = '';
    _selectedCategory.value = '';
    notifyListeners();
  }
}
