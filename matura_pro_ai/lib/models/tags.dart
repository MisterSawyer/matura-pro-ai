class Tags extends Iterable<String> {
  final List<String> _tags;

  Tags(List<String> tags) : _tags = tags;

  factory Tags.fromJson(dynamic json) {
    if (json is List) {
      return Tags(json.map((e) => e.toString()).toList());
    }
    throw const FormatException("Invalid JSON format for Tags: expected List<String>");
  }

  List<String> toJson() => _tags;

  @override
  Iterator<String> get iterator => _tags.iterator;
}
