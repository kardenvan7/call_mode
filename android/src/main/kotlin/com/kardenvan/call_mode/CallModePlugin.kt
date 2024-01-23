package com.kardenvan.call_mode

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class CallModePlugin: FlutterPlugin, MethodCallHandler, StreamHandler {
  private lateinit var methodChannel : MethodChannel
  private var eventSink: EventSink? = null
  private lateinit var listener: CallModeListener
  private val mainThreadHandler: Handler = Handler(Looper.getMainLooper())

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "call_mode_plugin_mc")
    methodChannel.setMethodCallHandler(this)

    val eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "call_mode_plugin_ec")
    eventChannel.setStreamHandler(this)

    listener = CallModeListener(context = flutterPluginBinding.applicationContext)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getCallMode" -> result.success(listener.getCallModeProgress().toString())
      "startWatcher" -> {
        listener.watch { value -> sendChangedNotification(value) }
        result.success(null)
      }
      "stopWatcher" -> {
        listener.stopWatcher()
        result.success(null)
      }
      "setWatcherInterval" -> {
        val argument = call.arguments

        if (argument is Int) {
          listener.setWatcherInterval(argument)
          result.success(null)
        } else {
          result.error("invalid_argument", "Argument is not double as required", {})
        }
      }
      else -> result.notImplemented()
    }
  }

  private fun sendChangedNotification(value: CallMode) {
    mainThreadHandler.post { eventSink?.success(value.toString()) }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }
}
