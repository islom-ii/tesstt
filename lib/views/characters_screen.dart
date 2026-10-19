import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/base_card.dart';
import '../core/widgets/base_text.dart';
import '../data/models/character_model.dart';
import '../view_models/character_bloc/character_bloc.dart';
import '../view_models/character_bloc/character_event.dart';
import '../view_models/character_bloc/character_state.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(
          text: 'CHARACTERS',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          BlocBuilder<CharacterBloc, CharacterState>(
            builder: (context, state) {
              final ascending = state is! CharacterLoaded || state.isAscending;
              return IconButton(
                tooltip: 'Sort by name',
                onPressed: () => context
                    .read<CharacterBloc>()
                    .add(SortCharacters(!ascending)),
                icon: Icon(
                  ascending ? Icons.sort_by_alpha : Icons.sort,
                  color: AppTheme.neonGreen,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          return switch (state) {
            CharacterLoading() || CharacterInitial() => const _LoadingView(),
            CharacterLoaded(:final characters) =>
              _CharacterGrid(characters: characters),
            CharacterError(:final message) => _ErrorView(
                message: message,
                onRetry: () => context
                    .read<CharacterBloc>()
                    .add(const FetchCharacters()),
              ),
          };
        },
      ),
    );
  }
}

class _CharacterGrid extends StatelessWidget {
  const _CharacterGrid({required this.characters});

  final List<CharacterModel> characters;

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const Center(child: BaseText(text: 'No characters found.'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return BaseCard(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    character.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: AppTheme.surface,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white54,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              BaseText(
                text: character.name,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              BaseText(
                text: '${character.species} · ${character.status}',
                fontSize: 10,
                color: Colors.white70,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppTheme.neonGreen),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

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
