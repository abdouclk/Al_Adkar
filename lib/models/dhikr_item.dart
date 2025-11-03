// Model for a single dhikr/adkar item
class DhikrItem {
  final String id; // Unique identifier
  final String text; // The dhikr text
  final String category; // Category (e.g., 'أذكار الصباح', 'أذكار المساء')
  final String? source; // Optional source reference

  DhikrItem({
    required this.id,
    required this.text,
    required this.category,
    this.source,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'source': source,
    };
  }

  // Create from JSON
  factory DhikrItem.fromJson(Map<String, dynamic> json) {
    return DhikrItem(
      id: json['id'] as String,
      text: json['text'] as String,
      category: json['category'] as String,
      source: json['source'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DhikrItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
