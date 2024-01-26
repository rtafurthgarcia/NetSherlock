import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CircularUsageWidget extends StatelessWidget {
  final int _currentUsage;
  final int _maxUsage;
  final String _name;
  final String _message;

  int get currentUsage => _currentUsage;
  int get maxUsage => _maxUsage;
  String get name => _name;
  String get message => _message;

  const CircularUsageWidget(
    {super.key,
    required int currentUsage,
    required int maxUsage,
    required String name,
    required String message
  }) : _name = name, _maxUsage = maxUsage, _currentUsage = currentUsage, _message = message;

  @override
  Widget build(BuildContext context) {
    return CircularStepProgressIndicator(
      totalSteps: _maxUsage,
      currentStep: _currentUsage,
      stepSize: 1,
      padding: 0,
      height: 150,
      width: 150,
      selectedStepSize: 15,
      roundedCap: (_, __) => true,
      selectedColor: Colors.greenAccent,
      unselectedColor: Colors.grey[200],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            softWrap: true,
            "$_currentUsage $_name $_message",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
