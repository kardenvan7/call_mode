import 'package:flutter/material.dart';
import 'package:call_mode/call_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CallModePlugin _plugin = CallModePlugin.instance;

  CallMode _callMode = CallMode.none;

  @override
  void initState() {
    super.initState();
    _getCallMode();
    _plugin.setListenerInterval(const Duration(seconds: 1));
  }

  void _subscribeToChanges() {
    _plugin.addListener(_isCallInProgressListener);
  }

  void _unsubscribeFromChanges() {
    _plugin.removeListener(_isCallInProgressListener);
  }

  void _isCallInProgressListener(CallMode mode) {
    setState(() => _callMode = mode);
  }

  void _getCallMode() {
    _plugin.getCallMode().then(
          (value) => setState(() => _callMode = value),
        );
  }

  String _getCallModeString() {
    return switch (_callMode) {
      CallMode.none => 'None',
      CallMode.ringing => 'Ringing',
      CallMode.inProgress => 'In progress',
    };
  }

  Color _getStateColor() {
    return switch (_callMode) {
      CallMode.inProgress => Colors.red,
      CallMode.none => Colors.green,
      CallMode.ringing => Colors.yellow
    };
  }

  @override
  void dispose() {
    _unsubscribeFromChanges();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _getStateColor(),
        appBar: AppBar(
          title: const Text('Call Mode Plugin'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _getCallMode(),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _subscribeToChanges(),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _unsubscribeFromChanges(),
            ),
          ],
        ),
        body: Center(
          child: Text('Call mode: ${_getCallModeString()}'),
        ),
      ),
    );
  }
}
