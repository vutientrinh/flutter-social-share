import 'package:flutter/material.dart';

class ShippingStatusBar extends StatelessWidget {
  final String status;

  ShippingStatusBar({required this.status});

  final List<Map<String, String>> stages = const [
    {"key": "PENDING", "label": "Pending"},
    {"key": "PICKED_UP", "label": "Pick up"},
    {"key": "IN_TRANSIT", "label": "In transit"},
    {"key": "DELIVERED", "label": "Delivered"},
    {"key": "FAILED", "label": "Fail"},
  ];

  int _getStatusIndex(String status) {
    if (status == "FAILED") {
      return stages.length - 1; // Jump to "FAILED"
    }
    return stages.indexWhere((stage) => stage["key"] == status);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getStatusIndex(status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stages.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value["label"]!;

        bool isActive;
        Color activeColor = Colors.green;

        if (status == "FAILED") {
          // Only Pending and Failed are active
          isActive = index == 0 || index == stages.length - 1;
          if (index == stages.length - 1) {
            activeColor = Colors.redAccent; // Red for failed
          }
        } else {
          isActive = index <= currentIndex;
        }

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  // Left line
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 4,
                        color: (status == "FAILED" && index == stages.length - 1) ||
                            (status != "FAILED" && index <= currentIndex)
                            ? activeColor
                            : Colors.grey[300],
                      ),
                    ),
                  // Dot
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 14, color: Colors.white),
                    ),
                  ),
                  // Right line
                  if (index < stages.length - 1)
                    Expanded(
                      child: Container(
                        height: 4,
                        color: (status != "FAILED" && index < currentIndex)
                            ? activeColor
                            : Colors.grey[300],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 4),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
