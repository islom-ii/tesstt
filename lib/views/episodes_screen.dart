import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/widgets/base_card.dart';
import '../core/widgets/base_text.dart';
import '../data/models/episode_model.dart';
import '../view_models/episode_bloc/episode_bloc.dart';
import '../view_models/episode_bloc/episode_event.dart';
import '../view_models/episode_bloc/episode_state.dart';

class EpisodesScreen extends StatelessWidget {
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(
          text: 'EPISODES',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          BlocBuilder<EpisodeBloc, EpisodeState>(
            builder: (context, state) {
              final ascending = state is! EpisodeLoaded || state.isAscending;
              return IconButton(
                tooltip: 'Sort by name',
                onPressed: () =>
                    context.read<EpisodeBloc>().add(SortEpisodes(!ascending)),
                icon: Icon(
                  ascending ? Icons.sort_by_alpha : Icons.sort,
                  color: const Color(0xFFFFC857),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<EpisodeBloc, EpisodeState>(
        builder: (context, state) {
          return switch (state) {
            EpisodeLoading() || EpisodeInitial() => const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC857)),
            ),
            EpisodeLoaded(:final episodes) => _EpisodeGrid(episodes: episodes),
            EpisodeError(:final message) => _RetryView(
              message: message,
              onRetry: () =>
                  context.read<EpisodeBloc>().add(const FetchEpisodes()),
            ),
          };
        },
      ),
    );
  }
}

class _EpisodeGrid extends StatelessWidget {
  const _EpisodeGrid({required this.episodes});

  final List<EpisodeModel> episodes;

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const Center(child: BaseText(text: 'No episodes found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return BaseCard(
          neonColor: const Color(0xFFFFC857),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.live_tv, color: Color(0xFFFFC857), size: 30),
              const Spacer(),
              BaseText(
                text: episode.name,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              BaseText(
                text: episode.episode,
                fontSize: 11,
                color: const Color(0xFFFFC857),
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              BaseText(
                text: episode.airDate,
                fontSize: 10,
                color: Colors.white70,
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
