import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CircularUsageWidget extends StatelessWidget {
  final int currentUsage;
  final int maxUsage;
  final String name;

  const CircularUsageWidget(
      {super.key,
      required this.currentUsage,
      required this.maxUsage,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return CircularStepProgressIndicator(
      totalSteps: maxUsage,
      currentStep: currentUsage,
      stepSize: 1,
      padding: 10,
      height: 150,
      width: 150,
      selectedStepSize: 15,
      roundedCap: (_, __) => true,
      gradientColor: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.topLeft,
        colors: [Colors.greenAccent, Colors.redAccent],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            softWrap: true,
            "$currentUsage $name left.",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
