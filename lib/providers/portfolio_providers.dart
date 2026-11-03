import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final caseStudyPageProvider =
    NotifierProvider.autoDispose<CaseStudyPageController, int>(
      CaseStudyPageController.new,
    );

class CaseStudyPageController extends Notifier<int> {
  @override
  int build() => 0;
  void select(int index) {
    if (state != index) state = index;
  }
}

@immutable
class NavigationState {
  final int activeSection;
  final bool scrolled;
  const NavigationState({this.activeSection = 0, this.scrolled = false});
}

final navigationProvider =
    NotifierProvider<NavigationController, NavigationState>(
      NavigationController.new,
    );

class NavigationController extends Notifier<NavigationState> {
  @override
  NavigationState build() => const NavigationState();
  void update({required int section, required bool scrolled}) {
    if (state.activeSection == section && state.scrolled == scrolled) return;
    state = NavigationState(activeSection: section, scrolled: scrolled);
  }
}

/// Riverpod owns resource lifetime. High-frequency updates remain paint/transform
/// listenables, so pointer and parallax changes do not rebuild provider consumers.
final viewportProvider = Provider.autoDispose<PortfolioViewport>((ref) {
  final viewport = PortfolioViewport();
  ref.onDispose(viewport.dispose);
  return viewport;
});

class PortfolioViewport {
  final controller = ScrollController();
  final parallax = ValueNotifier<double>(0);
  final cursor = ValueNotifier<Offset?>(null);
  void dispose() {
    controller.dispose();
    parallax.dispose();
    cursor.dispose();
  }
}

final contactSubmissionProvider =
    NotifierProvider.autoDispose<ContactSubmissionController, bool>(
      ContactSubmissionController.new,
    );

class ContactSubmissionController extends Notifier<bool> {
  @override
  bool build() => false;
  Future<void> submit(Future<void> Function() action) async {
    if (state) return;
    state = true;
    try {
      await action();
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
