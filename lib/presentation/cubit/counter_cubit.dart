import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<Map<String, int>> {
  CounterCubit() : super({});

  // ~:Initial Counter:~
  void setInitial(String key, int value) {
    emit({...state, key: value});
  }

  // ~:Increase Counter:~
  void increment(String type) => emit({...state, type: (state[type] ?? 1) + 1});

  // ~:Decrease Counter:~
  void decrement(String type) {
    final currentValue = state[type] ?? 1;
    if (currentValue > 0) {
      emit({...state, type: currentValue - 1});
    }
  }

  // ~:Reset Counter:~
  void reset() => emit({});

  // ~:Delete Counter:~
  void deleteKey(String key) {
    final newState = Map<String, int>.from(state)..remove(key);
    emit(newState);
  }

  Map<String, int> getCount() => state;

  // ~:Get value based on Map key:~
  int getValueWithKey(String userKey) {
    int val = 0;
    state.forEach((key, value) {
      if (key == userKey) val = value;
    });
    return val;
  }
}
