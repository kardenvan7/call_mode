import 'package:call_mode/call_mode.dart';
import 'package:flutter/material.dart';

class CallModeBuilder extends StatefulWidget {
  const CallModeBuilder({
    required this.builder,
  });

  final Widget Function(BuildContext context, CallMode mode) builder;

  @override
  _CallModeBuilderState createState() => _CallModeBuilderState();
}

class _CallModeBuilderState extends State<CallModeBuilder> {
  CallMode _currentCallMode = CallMode.none;

  void _callModeListener(BuildContext context, CallMode mode) {
    setState(() => _currentCallMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return CallModeListener(
      listener: _callModeListener,
      child: widget.builder(context, _currentCallMode),
    );
  }
}
