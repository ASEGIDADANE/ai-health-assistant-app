import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int currentStep; // 0-indexed visual step
  final int totalSteps;  // Total visual steps (e.g., 4)

  const CustomProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (int i = 0; i < totalSteps; i++) {
      bool isActive = i == currentStep;
      bool isCompleted = i < currentStep;

      // Add the step circle
      items.add(
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue.shade600 : (isCompleted ? Colors.green.shade500 : Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${i + 1}',
              style: TextStyle(
                color: (isActive || isCompleted) ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        )
      );

      // Add the connector line if not the last step
      if (i < totalSteps - 1) {
        items.add(
          Expanded(
            child: Container(
              height: 3.0,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              color: isCompleted ? Colors.green.shade500 : (isActive ? Colors.blue.shade600 : Colors.grey.shade300),
            ),
          ),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(children: items),
    );
  }
}