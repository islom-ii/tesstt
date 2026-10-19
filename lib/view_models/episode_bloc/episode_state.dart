import 'package:equatable/equatable.dart';

import '../../data/models/episode_model.dart';

sealed class EpisodeState extends Equatable {
  const EpisodeState();

  @override
  List<Object?> get props => [];
}

final class EpisodeInitial extends EpisodeState {
  const EpisodeInitial();
}

final class EpisodeLoading extends EpisodeState {
  const EpisodeLoading();
}

final class EpisodeLoaded extends EpisodeState {
  const EpisodeLoaded(this.episodes, {this.isAscending = true});

  final List<EpisodeModel> episodes;
  final bool isAscending;

  @override
  List<Object?> get props => [episodes, isAscending];
}

final class EpisodeError extends EpisodeState {
  const EpisodeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
