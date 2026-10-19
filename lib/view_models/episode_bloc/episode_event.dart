import 'package:equatable/equatable.dart';

sealed class EpisodeEvent extends Equatable {
  const EpisodeEvent();

  @override
  List<Object?> get props => [];
}

final class FetchEpisodes extends EpisodeEvent {
  const FetchEpisodes();
}

final class SortEpisodes extends EpisodeEvent {
  const SortEpisodes(this.ascending);

  final bool ascending;

  @override
  List<Object?> get props => [ascending];
}
