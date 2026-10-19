import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'base_container.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    required this.child,
    this.neonColor = AppTheme.neonGreen,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final Color neonColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      neonColor: neonColor,
      padding: padding,
      child: child,
    );
  }
}
