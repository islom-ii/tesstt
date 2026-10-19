class LocationModel {
  const LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
  });

  final int id;
  final String name;
  final String type;
  final String dimension;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      dimension: json['dimension'] as String,
    );
  }
}
