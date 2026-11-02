import 'package:flutter/material.dart';
import '../models/project.dart';

/// Crops the rendered preview while preserving the original screenshot file.
class ProjectPreviewImage extends StatelessWidget {
  final Project project;
  final WidgetBuilder errorBuilder;
  const ProjectPreviewImage({
    super.key,
    required this.project,
    required this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      project.previewAsset!,
      fit: BoxFit.contain,
      semanticLabel: '${project.title} application screenshot',
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) => errorBuilder(context),
    );
    if (project.previewTopCrop == 0 && project.previewBottomCrop == 0) {
      return image;
    }
    final visibleFraction =
        1 - project.previewTopCrop - project.previewBottomCrop;
    return AspectRatio(
      aspectRatio: project.previewSourceAspectRatio / visibleFraction,
      child: LayoutBuilder(
        builder: (context, box) {
          final fullHeight = box.maxWidth / project.previewSourceAspectRatio;
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: 0,
                top: -fullHeight * project.previewTopCrop,
                width: box.maxWidth,
                height: fullHeight,
                child: image,
              ),
            ],
          );
        },
      ),
    );
  }
}
