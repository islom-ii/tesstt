import 'package:equatable/equatable.dart';

sealed class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

final class FetchCharacters extends CharacterEvent {
  const FetchCharacters();
}

final class SortCharacters extends CharacterEvent {
  const SortCharacters(this.ascending);

  final bool ascending;

  @override
  List<Object?> get props => [ascending];
}
