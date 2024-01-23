# call_mode

A plugin for getting and listening to a current call mode

## Basic information

There are currently implemented only following call modes:

| inProgress                 | ringing               | none                       |
|----------------------------|-----------------------|----------------------------|
| A call is currently active | Incoming call ringing | No active or ringing calls |

## Getting Started

- Add the plugin to your dependencies in `pubspec.yaml`

    ```yaml
    dependencies:
        call_mode: ^0.1.0
    ```

- Run the following command to get the package:
    ```bash
    flutter pub get
    ```

- Import plugin to your dart file

    ```dart
    import 'package:call_mode/call_mode.dart';
    ```

## Usage

### Getting current call mode
You can get current call mode using `CallModePlugin.instance.getCallMode()` method.

### Listening to call mode changes
There are 2 ways to listen to call mode changes

1. Using `CallModePlugin`

    1. Add listener

        ```dart
        void someFunction() {
            CallModePlugin.instance.addListener(_callModeListener);
        }
        
        void _callModeListener(CallMode mode) {
            // TODO: your logic
        }
        ```

    1. Remove listener when you're done

        ```dart
        void dispose() {
            CallModePlugin.instance.removeListener(_callModeListener);
        }
        ```

2. Using `CallModeListener` or `CallModeBuilder` widgets

    - `CallModeListener`
        ```dart
        void _callModeListener(BuildContext context, CallMode mode) {
            // TODO: your logic
        }
        
        @override
        Widget build() {
            return CallModeListener(
                listener: _callModeListener,
                child: YourWidget(),
            );
        }
        ```

    - `CallModeBuilder`
        ```dart
        @override
        Widget build() {
            return CallModeBuilder(
                builder: (context, callMode) {
                    // TODO: your widgets
                },
            );
        }
        ```

### Additional methods
You can configure how often will an underlying system be checking for a call state.

Use `CallModePlugin.instance.setListenerInterval(Duration duration)` method.

***!!! WARNING !!!***

This method will affect ***ALL*** listeners in your app, including ones that are used inside
`CallModeBuilder`'s and `CallModeListener`'s. It is because there is only one state watcher
on platform side.

## Platform implementations

|            | Android                                                             | iOS                                                          |
|------------|---------------------------------------------------------------------|--------------------------------------------------------------|
| inProgress | `AudioManager.MODE_IN_CALL` or `AudioManager.MODE_IN_COMMUNICATION` | Any `CXCall` has hasEnded == false and hasConnected == true  |
| ringing    | `AudioManager.MODE_RINGTONE`                                        | Any `CXCall` has hasEnded == false and hasConnected == false |
| none       | Any other `AudioManager` mode                                       | No `CXCall`'s or all `CXCall`'s have hasEnded == true        |