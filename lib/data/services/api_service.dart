import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/character_model.dart';
import '../models/episode_model.dart';
import '../models/location_model.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://rickandmortyapi.com/api';
  final http.Client _client;

  Future<List<CharacterModel>> getCharacters() async {
    final results = await _getResults('character');
    return results
        .map((json) => CharacterModel.fromJson(json))
        .toList(growable: false);
  }

  Future<List<LocationModel>> getLocations() async {
    final results = await _getResults('location');
    return results
        .map((json) => LocationModel.fromJson(json))
        .toList(growable: false);
  }

  Future<List<EpisodeModel>> getEpisodes() async {
    final results = await _getResults('episode');
    return results
        .map((json) => EpisodeModel.fromJson(json))
        .toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> _getResults(String resource) async {
    final uri = Uri.parse('$_baseUrl/$resource');
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'Request for $resource failed (${response.statusCode}).',
        uri: uri,
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> ||
        decoded['results'] is! List<dynamic>) {
      throw const FormatException('The API returned an unexpected response.');
    }

    return (decoded['results'] as List<dynamic>).map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('The API returned an invalid item.');
      }
      return item;
    }).toList(growable: false);
  }
}
