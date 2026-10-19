import 'package:equatable/equatable.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

final class FetchLocations extends LocationEvent {
  const FetchLocations();
}

final class SortLocations extends LocationEvent {
  const SortLocations(this.ascending);

  final bool ascending;

  @override
  List<Object?> get props => [ascending];
}
