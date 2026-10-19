class EpisodeModel {
  const EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
  });

  final int id;
  final String name;
  final String airDate;
  final String episode;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      airDate: json['air_date'] as String,
      episode: json['episode'] as String,
    );
  }
}
