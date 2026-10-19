import 'package:equatable/equatable.dart';

import '../../data/models/location_model.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

final class LocationInitial extends LocationState {
  const LocationInitial();
}

final class LocationLoading extends LocationState {
  const LocationLoading();
}

final class LocationLoaded extends LocationState {
  const LocationLoaded(this.locations, {this.isAscending = true});

  final List<LocationModel> locations;
  final bool isAscending;

  @override
  List<Object?> get props => [locations, isAscending];
}

final class LocationError extends LocationState {
  const LocationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
