import 'dart:convert';
import 'dart:io';

class TravelPlanItem {
  const TravelPlanItem({required this.time, required this.title, this.memo = ''});

  final String time;
  final String title;
  final String memo;

  Map<String, dynamic> toJson() => {
        'time': time,
        'title': title,
        'memo': memo,
      };

  factory TravelPlanItem.fromJson(Map<String, dynamic> json) => TravelPlanItem(
        time: json['time'] as String? ?? '',
        title: json['title'] as String? ?? '',
        memo: json['memo'] as String? ?? '',
      );
}

class TravelPlan {
  const TravelPlan({
    required this.id,
    required this.title,
    required this.date,
    required this.items,
  });

  final String id;
  final String title;
  final DateTime date;
  final List<TravelPlanItem> items;

  TravelPlan copyWith({String? title, DateTime? date, List<TravelPlanItem>? items}) {
    return TravelPlan(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory TravelPlan.fromJson(Map<String, dynamic> json) => TravelPlan(
        id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: json['title'] as String? ?? '旅の予定',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        items: (json['items'] as List<dynamic>? ?? const [])
            .map((e) => TravelPlanItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  String toShareText() {
    final json = jsonEncode({'type': 'nekotomatatabi_plan_v1', 'plan': toJson()});
    final compressed = GZipCodec().encode(utf8.encode(json));
    return 'NKT1:${base64UrlEncode(compressed)}';
  }

  static TravelPlan? fromShareText(String raw) {
    try {
      final jsonText = raw.startsWith('NKT1:')
          ? utf8.decode(GZipCodec().decode(base64Url.decode(raw.substring(5))))
          : raw;
      final data = jsonDecode(jsonText) as Map<String, dynamic>;
      if (data['type'] != 'nekotomatatabi_plan_v1') return null;
      return TravelPlan.fromJson(Map<String, dynamic>.from(data['plan'] as Map));
    } catch (_) {
      return null;
    }
  }
}
