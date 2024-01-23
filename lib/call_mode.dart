import 'package:call_mode/src/call_mode_event_channel.dart';
import 'package:call_mode/src/call_mode_method_channel.dart';
import 'package:call_mode/src/call_mode.dart';
import 'package:call_mode/src/subscription_manager.dart';

export 'package:call_mode/src/call_mode_listener.dart';
export 'package:call_mode/src/call_mode.dart';

/// A class that allows for getting/listening to a current [CallMode].
///
/// [CallMode] corresponds to:
///
/// ### Android:
/// - [inProgress] => AudioManager.MODE_IN_CALL or
/// AudioManager.MODE_IN_COMMUNICATION
/// - [ringing] => AudioManager.MODE_RINGTONE
/// - [none] => other AudioManager modes
///
/// ### iOS:
/// - [inProgress] => any call has [call.hasEnded] == `false` and [call.hasConnected] == `true`
/// - [ringing] => any call has [call.hasEnded] == `false` and [call.hasConnected] == `false`
/// - [none] => no calls or all calls have [call.hasEnded] == `true`
///
class CallModePlugin {
  CallModePlugin._();

  static final CallModePlugin instance = CallModePlugin._();

  final _methodChannel = CallModeMethodChannel();
  final _eventChannel = CallModeEventChannel();

  late final _subManager = SubscriptionManager(
    eventChannel: _eventChannel,
    methodChannel: _methodChannel,
  );

  /// Return current [CallMode]
  ///
  Future<CallMode> getCallMode() => _methodChannel.getCallMode();

  void addListener(void Function(CallMode) listener) =>
      _subManager.addListener(listener);

  void removeListener(void Function(CallMode) listener) =>
      _subManager.removeListener(listener);

  void setListenerInterval(Duration duration) =>
      _methodChannel.setWatcherInterval(duration);
}
