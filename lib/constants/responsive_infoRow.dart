import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// A responsive widget to display a label/value pair.
/// ---------------------------------------------------------------------------
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding added around the entire row.
      // Provides vertical spacing of 4.0 on top and bottom,
      // with no horizontal padding.
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 0.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.visible,
            ),
          ),
          // SizedBox added between the two Expanded widgets.
          const SizedBox(width: 1),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),


              overflow: TextOverflow.clip,


            ),
          ),
        ],
      ),
    );
  }
}
