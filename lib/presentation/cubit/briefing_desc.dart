// lib/presentation/cubit/briefing_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BriefingDescCubit extends Cubit<List<TextEditingController>> {
  BriefingDescCubit() : super([TextEditingController()]);

  void addField() {
    final newState = List<TextEditingController>.from(state)
      ..add(TextEditingController());
    emit(newState);
  }

  void removeField(int index) {
    if (state.length > 1) {
      // Keep at least one field
      final newState = List<TextEditingController>.from(state)..removeAt(index);
      emit(newState);
    }
  }

  void resetFields() {
    final newState = [TextEditingController()];
    emit(newState);
  }

  @override
  Future<void> close() {
    // Dispose all controllers when cubit is closed
    for (var controller in state) {
      controller.dispose();
    }
    return super.close();
  }
}
