import 'dart:async';

import 'package:call_mode/src/call_mode.dart';
import 'package:call_mode/src/call_mode_parser.dart';
import 'package:flutter/services.dart';

class CallModeEventChannel {
  final EventChannel _eventChannel = const EventChannel('call_mode_plugin_ec');
  final _parser = CallModeParser();

  late final Stream _stream = _eventChannel.receiveBroadcastStream();

  StreamSubscription listen(void Function(CallMode) listener) {
    return _stream.listen(
      (value) {
        if (value is String) {
          final mode = _parser.fromString(value);

          listener(mode);
        }
      },
    );
  }
}
