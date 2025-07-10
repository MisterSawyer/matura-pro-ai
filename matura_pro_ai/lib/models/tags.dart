class Tags {
  final List<String> tags;

  Tags(this.tags);

  factory Tags.fromJson(dynamic json) {
    if (json is List) {
      return Tags(json.map((e) => e.toString()).toList());
    }
    throw const FormatException("Invalid JSON format for Tags: expected List<String>");
  }

  List<String> toJson() => tags;
}
