import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/base_card.dart';
import '../core/widgets/base_text.dart';
import '../data/models/location_model.dart';
import '../view_models/location_bloc/location_bloc.dart';
import '../view_models/location_bloc/location_event.dart';
import '../view_models/location_bloc/location_state.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(
          text: 'LOCATIONS',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              final ascending = state is! LocationLoaded || state.isAscending;
              return IconButton(
                tooltip: 'Sort by name',
                onPressed: () => context
                    .read<LocationBloc>()
                    .add(SortLocations(!ascending)),
                icon: Icon(
                  ascending ? Icons.sort_by_alpha : Icons.sort,
                  color: AppTheme.neonBlue,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          return switch (state) {
            LocationLoading() || LocationInitial() => const Center(
                child: CircularProgressIndicator(color: AppTheme.neonBlue),
              ),
            LocationLoaded(:final locations) =>
              _LocationGrid(locations: locations),
            LocationError(:final message) => _RetryView(
                message: message,
                onRetry: () =>
                    context.read<LocationBloc>().add(const FetchLocations()),
              ),
          };
        },
      ),
    );
  }
}

class _LocationGrid extends StatelessWidget {
  const _LocationGrid({required this.locations});

  final List<LocationModel> locations;

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return const Center(child: BaseText(text: 'No locations found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return BaseCard(
          neonColor: AppTheme.neonBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.public, color: AppTheme.neonBlue, size: 30),
              const Spacer(),
              BaseText(
                text: location.name,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              BaseText(
                text: location.type,
                fontSize: 10,
                color: Colors.white70,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              BaseText(
                text: location.dimension,
                fontSize: 10,
                color: Colors.white54,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RetryView extends StatelessWidget {
  const _RetryView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseText(
              text: message,
              color: Colors.redAccent,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
