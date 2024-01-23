import 'package:flutter/material.dart';
import 'package:call_mode/call_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String _getCallModeString(CallMode mode) {
    return switch (mode) {
      CallMode.none => 'None',
      CallMode.ringing => 'Ringing',
      CallMode.inProgress => 'In progress',
    };
  }

  Color _getStateColor(CallMode mode) {
    return switch (mode) {
      CallMode.inProgress => Colors.red,
      CallMode.none => Colors.green,
      CallMode.ringing => Colors.yellow
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CallModeBuilder(
        builder: (context, callMode) {
          return Scaffold(
            backgroundColor: _getStateColor(callMode),
            body: Center(
              child: Text('Call mode: ${_getCallModeString(callMode)}'),
            ),
          );
        },
      ),
    );
  }
}
