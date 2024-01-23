import 'dart:async';

import 'package:call_mode/src/call_mode_event_channel.dart';
import 'package:call_mode/src/call_mode_method_channel.dart';
import 'package:call_mode/src/call_mode.dart';

class SubscriptionManager {
  SubscriptionManager({
    required CallModeMethodChannel methodChannel,
    required CallModeEventChannel eventChannel,
  })  : _eventChannel = eventChannel,
        _methodChannel = methodChannel;

  final CallModeMethodChannel _methodChannel;
  final CallModeEventChannel _eventChannel;
  final Map<int, StreamSubscription> _hashToSub = {};

  bool _isWatcherActive = false;

  void addListener(void Function(CallMode) listener) {
    final prevSub = _hashToSub[listener.hashCode];

    if (prevSub != null) prevSub.cancel();

    // ignore: cancel_subscriptions
    final newSub = _eventChannel.listen(listener);

    _hashToSub[listener.hashCode] = newSub;

    _startWatcherIfNotActive();
  }

  void removeListener(void Function(CallMode) listener) {
    _hashToSub.remove(listener.hashCode)?.cancel();

    _stopWatcherIfNoSubsAndActive();
  }

  void _stopWatcherIfNoSubsAndActive() {
    if (_hashToSub.isEmpty) _stopWatcherIfActive();
  }

  void _stopWatcherIfActive() {
    if (_isWatcherActive) {
      _methodChannel.stopWatcher();
      _isWatcherActive = false;
    }
  }

  void _startWatcherIfNotActive() {
    if (!_isWatcherActive) {
      _methodChannel.startWatcher();
      _isWatcherActive = true;
    }
  }
}
