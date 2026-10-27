class Project {
  final String title, category, description, url;
  final String details;
  final String linkLabel;
  final String? previewAsset, iconAsset;
  final List<String> highlights, stack;
  final int color;
  const Project(
    this.title,
    this.category,
    this.description,
    this.url,
    this.color, {
    this.details = '',
    this.linkLabel = 'Visit live app',
    this.previewAsset,
    this.iconAsset,
    this.highlights = const [],
    this.stack = const [],
  });
}
