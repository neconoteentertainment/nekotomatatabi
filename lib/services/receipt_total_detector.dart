class ReceiptOcrLine {
  const ReceiptOcrLine({
    required this.text,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;

  double get centerX => (left + right) / 2;
  double get centerY => (top + bottom) / 2;
  double get height => bottom - top;
}

class ReceiptTotalDetector {
  static const _positiveKeywords = <String, int>{
    'お支払合計': 48,
    'お支払い合計': 48,
    '税込合計': 44,
    '総合計': 42,
    '合計金額': 40,
    '合計': 36,
    'grandtotal': 42,
    'total': 36,
  };
  static const _negativeKeywords = <String>[
    '小計', '税額', '消費税', '内税', '外税', 'お預り', 'お預かり',
    '預り', '預かり', 'お釣り', '釣り', '電話', 'tel', '登録番号',
    'jan', 'レジ番号', 'お客様番号',
  ];

  static int? detect(List<ReceiptOcrLine> source) {
    final lines = source
        .map((line) => _NormalizedLine(line, _normalize(line.text)))
        .where((line) => line.text.isNotEmpty)
        .toList();
    final keywordLines = <_KeywordLine>[];
    for (final line in lines) {
      if (_isExcluded(line.text)) continue;
      for (final entry in _positiveKeywords.entries) {
        if (line.text.contains(entry.key)) {
          keywordLines.add(_KeywordLine(line, entry.value));
          break;
        }
      }
    }
    if (keywordLines.isEmpty) return null;

    final candidates = <_Candidate>[];
    for (final line in lines) {
      if (_isExcluded(line.text) || _looksLikeMetadata(line.text)) continue;
      for (final amount in _amounts(line.text)) {
        var bestScore = -1;
        for (final keyword in keywordLines) {
          final dy = (line.source.centerY - keyword.line.source.centerY).abs();
          final rowTolerance = (line.source.height > keyword.line.source.height
                  ? line.source.height
                  : keyword.line.source.height) *
              1.25;
          var score = keyword.weight;
          if (identical(line, keyword.line)) {
            score += 100;
          } else if (dy <= rowTolerance &&
              line.source.centerX >= keyword.line.source.centerX) {
            score += 78;
          } else if (dy <= rowTolerance * 2.2) {
            score += 42;
          } else {
            continue;
          }
          if (amount.hasCurrency) score += 24;
          score -= dy.round().clamp(0, 30).toInt();
          if (score > bestScore) bestScore = score;
        }
        if (bestScore >= 0) candidates.add(_Candidate(amount.value, bestScore));
      }
    }
    if (candidates.isEmpty) return null;
    candidates.sort((a, b) => b.score.compareTo(a.score));
    final best = candidates.first;
    if (best.score < 100) return null;
    final runnerUp = candidates.skip(1).where((c) => c.value != best.value).firstOrNull;
    if (runnerUp != null && best.score - runnerUp.score < 12) return null;
    return best.value;
  }

  static String _normalize(String input) {
    const full = '０１２３４５６７８９';
    var value = input.toLowerCase();
    for (var i = 0; i < full.length; i++) {
      value = value.replaceAll(full[i], '$i');
    }
    return value.replaceAll(RegExp(r'[\s　]'), '');
  }

  static bool _isExcluded(String text) =>
      _negativeKeywords.any(text.contains);

  static bool _looksLikeMetadata(String text) {
    return RegExp(r'\d{4}[/\-.]\d{1,2}[/\-.]\d{1,2}').hasMatch(text) ||
        RegExp(r'\d{1,2}:\d{2}').hasMatch(text) ||
        RegExp(r'(?:0\d{1,4}[-()]?)?\d{2,4}-\d{3,4}').hasMatch(text) ||
        RegExp(r'\d{9,}').hasMatch(text.replaceAll(RegExp(r'[,\-.]'), ''));
  }

  static Iterable<_Amount> _amounts(String text) sync* {
    final pattern = RegExp(r'([¥￥\\]?)(\d[\d,]{0,7})(円?)');
    for (final match in pattern.allMatches(text)) {
      final raw = match.group(2)!.replaceAll(',', '');
      final value = int.tryParse(raw);
      if (value == null || value <= 0 || value >= 100000000) continue;
      final hasCurrency = match.group(1)!.isNotEmpty || match.group(3)!.isNotEmpty;
      yield _Amount(value, hasCurrency);
    }
  }
}

class _NormalizedLine {
  const _NormalizedLine(this.source, this.text);
  final ReceiptOcrLine source;
  final String text;
}

class _KeywordLine {
  const _KeywordLine(this.line, this.weight);
  final _NormalizedLine line;
  final int weight;
}

class _Amount {
  const _Amount(this.value, this.hasCurrency);
  final int value;
  final bool hasCurrency;
}

class _Candidate {
  const _Candidate(this.value, this.score);
  final int value;
  final int score;
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
