import Flutter
import UIKit

public class CallModePlugin: NSObject, FlutterPlugin {
    private let listener: CallModeListener = CallModeListener()
    private var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "call_mode_plugin_mc",
            binaryMessenger: registrar.messenger()
        )
        let eventChannel = FlutterEventChannel(
            name: "call_mode_plugin_ec",
            binaryMessenger: registrar.messenger()
        )
        let instance = CallModePlugin()
        eventChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "getCallMode":
            result(listener.getCallMode().toString())
        case "startWatcher":
            listener.watch { callMode in
                self.eventSink?(callMode.toString())
            }
            result(nil)
        case "stopWatcher":
            listener.stopWatcher()
            result(nil)
        case "setWatcherInterval":
            let argument = call.arguments
        
            if let intervalInMicroseconds = argument as? Int {
                listener.setWatcherInterval(
                    intervalInMicroseconds: intervalInMicroseconds
                )
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "invalid_argument",
                        message: "argument is not double as required",
                        details: {}
                    )
                )
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension CallModePlugin: FlutterStreamHandler {
    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
