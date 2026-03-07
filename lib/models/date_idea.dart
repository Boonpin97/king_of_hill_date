/// A simple model representing a date idea.
class DateIdea {
  final String id;
  final String name;
  final String description;
  final String time;
  final String imagePath;

  const DateIdea({
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    required this.imagePath,
  });

  /// Creates a DateIdea from a JSON map.
  factory DateIdea.fromJson(Map<String, dynamic> json) {
    return DateIdea(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      time: json['time'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  /// Converts the DateIdea to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'time': time,
      'imagePath': imagePath,
    };
  }
}
