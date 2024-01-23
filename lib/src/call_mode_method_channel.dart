import 'package:call_mode/src/call_mode.dart';
import 'package:call_mode/src/call_mode_parser.dart';
import 'package:flutter/services.dart';

class CallModeMethodChannel {
  final _methodChannel = const MethodChannel('call_mode_plugin_mc');
  final _parser = CallModeParser();

  Future<CallMode> getCallMode() async {
    final result = await _methodChannel.invokeMethod('getCallMode');

    return _parser.fromString(result as String);
  }

  Future<void> startWatcher() => _methodChannel.invokeMethod('startWatcher');

  Future<void> stopWatcher() => _methodChannel.invokeMethod('stopWatcher');

  Future<void> setWatcherInterval(Duration duration) =>
      _methodChannel.invokeMethod(
        'setWatcherInterval',
        duration.inMicroseconds,
      );
}
