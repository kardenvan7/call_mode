import 'dart:async';

import 'package:call_mode/call_mode.dart';
import 'package:call_mode/src/call_mode_event_channel.dart';
import 'package:call_mode/src/call_mode_method_channel.dart';
import 'package:call_mode/src/subscription_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final mockMethodChannel = _MockMethodChannel();
  final mockEventChannel = _MockEventChannel();

  SubscriptionManager getUut() => SubscriptionManager(
        methodChannel: mockMethodChannel,
        eventChannel: mockEventChannel,
      );

  group(
    'SubscriptionManager tests',
    () {
      // Common set up

      void fakeListener1(CallMode mode) {}
      void fakeListener2(CallMode mode) {}

      late _MockStreamSubscription fakeStreamSub1;
      late _MockStreamSubscription fakeStreamSub2;

      setUpAll(() {
        when(() => mockMethodChannel.startWatcher()).thenAnswer((_) async {});
        when(() => mockMethodChannel.stopWatcher()).thenAnswer((_) async {});
      });

      setUp(() {
        fakeStreamSub1 = _MockStreamSubscription();
        fakeStreamSub2 = _MockStreamSubscription();

        when(() => mockEventChannel.listen(fakeListener1))
            .thenReturn(fakeStreamSub1);
        when(() => mockEventChannel.listen(fakeListener2))
            .thenReturn(fakeStreamSub2);
      });

      test(
        'Activates watcher ONLY after the first subscription',
        () {
          // Local setup

          final uut = getUut();

          // Test

          uut.addListener(fakeListener1);

          verify(() => mockMethodChannel.startWatcher()).called(1);

          uut.addListener(fakeListener2);

          verifyNever(() => mockMethodChannel.startWatcher());
        },
      );

      test(
        'Deactivates watcher after all subscriptions are cancelled',
        () {
          // Local setup

          final uut = getUut();

          uut.addListener(fakeListener1);
          uut.addListener(fakeListener2);

          // Test

          uut.removeListener(fakeListener1);

          verifyNever(() => mockMethodChannel.stopWatcher());

          uut.removeListener(fakeListener2);

          verify(() => mockMethodChannel.stopWatcher()).called(1);
        },
      );

      test(
        'Cancels subscription after removing listener',
        () async {
          // Local setup

          final uut = getUut();

          uut.addListener(fakeListener1);
          uut.addListener(fakeListener2);

          // Test

          uut.removeListener(fakeListener1);

          expect(fakeStreamSub1.isCanceled, true);
          expect(fakeStreamSub2.isCanceled, false);
        },
      );
    },
  );
}

class _MockMethodChannel extends Mock implements CallModeMethodChannel {}

class _MockEventChannel extends Mock implements CallModeEventChannel {}

class _MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {
  bool isCanceled = false;

  @override
  Future<void> cancel() {
    return Future.sync(() => isCanceled = true);
  }
}
