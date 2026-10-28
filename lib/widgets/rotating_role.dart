import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/portfolio_data.dart';

/// Keeps typewriter updates local to one text widget; pauses outside the viewport.
class RotatingRole extends StatefulWidget {
  const RotatingRole({super.key});
  @override
  State<RotatingRole> createState() => _RotatingRoleState();
}

class _RotatingRoleState extends State<RotatingRole> {
  Timer? timer;
  bool visible = false;
  bool reduced = false;
  bool deleting = false;
  int role = 0, count = 0, pause = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reduced = MediaQuery.disableAnimationsOf(context);
    syncTimer();
  }

  void syncTimer() {
    if (!mounted) return;
    if (!visible || reduced) {
      timer?.cancel();
      timer = null;
    } else {
      timer ??= Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (pause > 0) {
          pause--;
          return;
        }
        setState(() {
          if (deleting) {
            count--;
            if (count == 0) {
              deleting = false;
              role = (role + 1) % PortfolioData.roles.length;
              pause = 3;
            }
          } else {
            count++;
            if (count == PortfolioData.roles[role].length) {
              deleting = true;
              pause = 24;
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: ObjectKey(this),
    onVisibilityChanged: (info) {
      visible = info.visibleFraction > 0;
      syncTimer();
    },
    child: RepaintBoundary(
      child: Text(
        reduced
            ? PortfolioData.roles.first
            : '${PortfolioData.roles[role].substring(0, count)}│',
        style: TextStyle(
          fontSize: 17,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .6),
        ),
      ),
    ),
  );
}
