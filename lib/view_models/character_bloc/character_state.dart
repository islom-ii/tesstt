import 'package:equatable/equatable.dart';

import '../../data/models/character_model.dart';

sealed class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

final class CharacterInitial extends CharacterState {
  const CharacterInitial();
}

final class CharacterLoading extends CharacterState {
  const CharacterLoading();
}

final class CharacterLoaded extends CharacterState {
  const CharacterLoaded(this.characters, {this.isAscending = true});

  final List<CharacterModel> characters;
  final bool isAscending;

  @override
  List<Object?> get props => [characters, isAscending];
}

final class CharacterError extends CharacterState {
  const CharacterError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
