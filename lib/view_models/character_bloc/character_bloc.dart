import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/api_service.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc(ApiService apiService) : super(const CharacterInitial()) {
    on<FetchCharacters>((event, emit) async {
      emit(const CharacterLoading());
      try {
        final characters = List.of(await apiService.getCharacters())
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
        emit(CharacterLoaded(List.unmodifiable(characters)));
      } on Exception catch (error) {
        emit(CharacterError(error.toString()));
      }
    });

    on<SortCharacters>((event, emit) {
      final currentState = state;
      if (currentState is! CharacterLoaded) return;

      final characters = List.of(currentState.characters)
        ..sort((a, b) {
          final comparison =
              a.name.toLowerCase().compareTo(b.name.toLowerCase());
          return event.ascending ? comparison : -comparison;
        });

      emit(CharacterLoaded(
        List.unmodifiable(characters),
        isAscending: event.ascending,
      ));
    });
  }
}
