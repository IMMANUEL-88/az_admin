
import 'package:flutter/material.dart';

import 'custom_curved_edge.dart';

class ECurvedEdgeWidget extends StatelessWidget {
  const ECurvedEdgeWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ECustomCurvedEdges(),
      child: child,
    );
  }
}
