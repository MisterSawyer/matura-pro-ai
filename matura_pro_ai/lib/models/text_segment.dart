class TextSegment {
  final String? text;
  final int? gapIndex;

  const TextSegment._({this.text, this.gapIndex});

  bool get isGap => gapIndex != null;

  factory TextSegment.text(String t) => TextSegment._(text: t);
  factory TextSegment.gap(int i) => TextSegment._(gapIndex: i);
}