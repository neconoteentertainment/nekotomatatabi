class TravelMemory {
  const TravelMemory({
    required this.id,
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.prefecture,
    required this.visitedAt,
    required this.memo,
    required this.photoPaths,
  });

  final String id;
  final String placeName;
  final double latitude;
  final double longitude;
  final String prefecture;
  final DateTime visitedAt;
  final String memo;
  final List<String> photoPaths;

  TravelMemory copyWith({
    String? placeName,
    double? latitude,
    double? longitude,
    String? prefecture,
    DateTime? visitedAt,
    String? memo,
    List<String>? photoPaths,
  }) {
    return TravelMemory(
      id: id,
      placeName: placeName ?? this.placeName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      prefecture: prefecture ?? this.prefecture,
      visitedAt: visitedAt ?? this.visitedAt,
      memo: memo ?? this.memo,
      photoPaths: photoPaths ?? this.photoPaths,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'placeName': placeName,
        'latitude': latitude,
        'longitude': longitude,
        'prefecture': prefecture,
        'visitedAt': visitedAt.toIso8601String(),
        'memo': memo,
        'photoPaths': photoPaths,
      };

  factory TravelMemory.fromJson(Map<String, dynamic> json) {
    return TravelMemory(
      id: json['id'] as String,
      placeName: json['placeName'] as String? ?? '名称未設定',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      prefecture: json['prefecture'] as String? ?? '不明',
      visitedAt: DateTime.tryParse(json['visitedAt'] as String? ?? '') ?? DateTime.now(),
      memo: json['memo'] as String? ?? '',
      photoPaths: (json['photoPaths'] as List<dynamic>? ?? const []).cast<String>(),
    );
  }
}

class NearbyPlace {
  const NearbyPlace({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.category,
  });

  final String name;
  final double latitude;
  final double longitude;
  final String category;
}
