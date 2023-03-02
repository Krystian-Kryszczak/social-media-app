class Rules {
  final DateTime createdTime;
  final Map<String, String> sections;

  Rules({
    required this.createdTime,
    required this.sections,
  });

  factory Rules.fromJson(Map<String, dynamic> data) =>
    Rules(
      createdTime: DateTime.parse(data['createdTime'] as String),
      sections: (data['sections'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as String))
    );
}
