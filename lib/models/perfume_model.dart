class PerfumeModel {
  final String id;
  final String name;
  final String brandLine;
  final double price;
  final String descriptionEn;
  final String descriptionFr;
  final String imageUrl;
  final List<String> imageUrls;
  final bool isFeatured;

  PerfumeModel({
    required this.id,
    required this.name,
    required this.brandLine,
    required this.price,
    required this.descriptionEn,
    required this.descriptionFr,
    required this.imageUrl,
    required this.imageUrls,
    this.isFeatured = false,
  });

  // Dynamic automatic property getter for backwards-compatibility errors
  String get description {
    return descriptionEn.isNotEmpty ? descriptionEn : descriptionFr;
  }
}