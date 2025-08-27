import 'package:flutter_bloc/flutter_bloc.dart';

class FuFilterControlsCubit extends Cubit<FuFilterControlsState> {
  FuFilterControlsCubit() : super(FuFilterControlsState());

  void toggleFilter(String filterType, bool value) {
    final newFilters = Map<String, bool>.from(state.activeFilters);
    if (filterType == 'notFollowedUp' || filterType == 'deal') {
      for (var key in newFilters.keys) {
        if (key == filterType) {
          newFilters[key] = value;
        } else {
          newFilters[key] = false;
        }
      }
    } else {
      newFilters[filterType] = value;
    }
    emit(state.copyWith(activeFilters: newFilters));
  }

  void resetFilters() {
    emit(FuFilterControlsState());
  }
}

class FuFilterControlsState {
  final Map<String, bool> activeFilters;

  FuFilterControlsState({
    Map<String, bool>? activeFilters,
  }) : activeFilters = activeFilters ??
            {
              'notFollowedUp': true,
              'deal': false,
              'sortByName': false,
            };

  FuFilterControlsState copyWith({
    Map<String, bool>? activeFilters,
  }) {
    return FuFilterControlsState(
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}
