const expenseCategories = <String>[
  '食事',
  '交通',
  '宿泊',
  'お土産',
  '入場・体験',
  'その他',
];

class TravelExpense {
  const TravelExpense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.memo,
    required this.tripName,
  });

  final String id;
  final int amount;
  final String category;
  final DateTime date;
  final String memo;
  final String tripName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'memo': memo,
        'tripName': tripName,
      };

  factory TravelExpense.fromJson(Map<String, dynamic> json) => TravelExpense(
        id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
        amount: (json['amount'] as num?)?.toInt() ?? 0,
        category: expenseCategories.contains(json['category'])
            ? json['category'] as String
            : 'その他',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        memo: json['memo'] as String? ?? '',
        tripName: json['tripName'] as String? ?? '',
      );
}
