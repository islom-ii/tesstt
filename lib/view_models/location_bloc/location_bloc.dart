import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/api_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc(ApiService apiService) : super(const LocationInitial()) {
    on<FetchLocations>((event, emit) async {
      emit(const LocationLoading());
      try {
        final locations = List.of(await apiService.getLocations())
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
        emit(LocationLoaded(List.unmodifiable(locations)));
      } on Exception catch (error) {
        emit(LocationError(error.toString()));
      }
    });

    on<SortLocations>((event, emit) {
      final currentState = state;
      if (currentState is! LocationLoaded) return;

      final locations = List.of(currentState.locations)
        ..sort((a, b) {
          final comparison =
              a.name.toLowerCase().compareTo(b.name.toLowerCase());
          return event.ascending ? comparison : -comparison;
        });

      emit(LocationLoaded(
        List.unmodifiable(locations),
        isAscending: event.ascending,
      ));
    });
  }
}
