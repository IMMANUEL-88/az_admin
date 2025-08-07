
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import 'circular_container.dart';
import 'curved_edge_widget.dart';

class EPrimaryHeaderContainer extends StatelessWidget {
  const EPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ECurvedEdgeWidget(
      child: Container(
        color: EColors.primaryColor,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: ECircularContainer(
                backgroundColor: EColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 110,
              right: 250,
              child: ECircularContainer(
                backgroundColor: EColors.textWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
