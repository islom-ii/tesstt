import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/api_service.dart';
import 'episode_event.dart';
import 'episode_state.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  EpisodeBloc(ApiService apiService) : super(const EpisodeInitial()) {
    on<FetchEpisodes>((event, emit) async {
      emit(const EpisodeLoading());
      try {
        final episodes = List.of(await apiService.getEpisodes())
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
        emit(EpisodeLoaded(List.unmodifiable(episodes)));
      } on Exception catch (error) {
        emit(EpisodeError(error.toString()));
      }
    });

    on<SortEpisodes>((event, emit) {
      final currentState = state;
      if (currentState is! EpisodeLoaded) return;

      final episodes = List.of(currentState.episodes)
        ..sort((a, b) {
          final comparison =
              a.name.toLowerCase().compareTo(b.name.toLowerCase());
          return event.ascending ? comparison : -comparison;
        });

      emit(EpisodeLoaded(
        List.unmodifiable(episodes),
        isAscending: event.ascending,
      ));
    });
  }
}
