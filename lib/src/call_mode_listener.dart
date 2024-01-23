import 'package:call_mode/call_mode.dart';
import 'package:flutter/material.dart';

class CallModeListener extends StatefulWidget {
  const CallModeListener({
    required this.listener,
    required this.child,
    super.key,
  });

  final void Function(BuildContext context, CallMode isCallMode) listener;
  final Widget child;

  @override
  State<CallModeListener> createState() => _CallModeListenerState();
}

class _CallModeListenerState extends State<CallModeListener> {
  final CallModePlugin _plugin = CallModePlugin.instance;

  @override
  void initState() {
    super.initState();
    _getCallMode();
    _plugin.addListener(_onCallModeReceived);
  }

  void _onCallModeReceived(CallMode callMode) {
    widget.listener(context, callMode);
  }

  void _getCallMode() {
    _plugin.getCallMode().then(_onCallModeReceived);
  }

  @override
  void dispose() {
    _plugin.removeListener(_onCallModeReceived);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
