class Dimension {
  int? width;
  int? height;

  bool? get cacheWidth {
    if (width != null && height != null) {
      return width! <= height!;
    }
    return null;
  }

  Dimension({this.width, this.height});

  factory Dimension.fromJson(Map<String, dynamic> json) => Dimension(
    width: json['width'] as int?,
    height: json['height'] as int?,
  );
}
