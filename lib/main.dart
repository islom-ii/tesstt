import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/services/api_service.dart';
import 'view_models/character_bloc/character_bloc.dart';
import 'view_models/character_bloc/character_event.dart';
import 'view_models/episode_bloc/episode_bloc.dart';
import 'view_models/episode_bloc/episode_event.dart';
import 'view_models/location_bloc/location_bloc.dart';
import 'view_models/location_bloc/location_event.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const RickAndMortyApp());
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CharacterBloc(apiService)..add(const FetchCharacters()),
        ),
        BlocProvider(
          create: (_) => LocationBloc(apiService)..add(const FetchLocations()),
        ),
        BlocProvider(
          create: (_) => EpisodeBloc(apiService)..add(const FetchEpisodes()),
        ),
      ],
      child: MaterialApp(
        title: 'Rick and Morty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
