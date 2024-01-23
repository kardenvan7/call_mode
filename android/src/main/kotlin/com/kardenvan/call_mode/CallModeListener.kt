package com.kardenvan.call_mode

import android.content.Context
import android.media.AudioManager
import java.util.Timer
import kotlin.concurrent.timer

class CallModeListener(private var context: Context) {
    private val defaultTimerIntervalMicroseconds: Int = 100000

    private var intervalInMicroseconds: Int = defaultTimerIntervalMicroseconds
    private var timerTask: Timer? = null
    private var callback: ((CallMode)->Unit)? = null
    private var callMode: CallMode

    init {
        callMode = getCallModeProgress()
    }

    fun getCallModeProgress() : CallMode {
        return getCallModeInternal()
    }

    fun watch(callback: ((CallMode)->Unit)) {
        this.callback = callback
        resetTimer()
    }

    fun stopWatcher() {
        this.callback = null
        stopAndRemoveTimer()
    }

    fun setWatcherInterval(intervalInMicroseconds: Int) {
        this.intervalInMicroseconds = intervalInMicroseconds

        resetTimer()
    }

    private fun resetTimer() {
        if (callback == null) return

        stopAndRemoveTimer()

        val periodInMilliseconds = (intervalInMicroseconds / 1000).toLong()

        timerTask = timer(
            period = periodInMilliseconds,
        ) {
            if (callback == null) {
                stopAndRemoveTimer()
            }

            val newCallMode = getCallModeProgress()

            if (callMode != newCallMode) {
                callMode = newCallMode
                triggerCallback(newCallMode)
            }
        }
    }

    private fun triggerCallback(value: CallMode) {
        callback?.let { it(value) }
    }

    private fun stopAndRemoveTimer() {
        timerTask?.cancel()
        timerTask?.purge()
        timerTask = null
    }

    private fun getCallModeInternal() : CallMode {
        val service: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

        return when (service.mode) {
            AudioManager.MODE_IN_CALL -> CallMode.IN_PROGRESS
            AudioManager.MODE_IN_COMMUNICATION -> CallMode.IN_PROGRESS
            AudioManager.MODE_RINGTONE -> CallMode.RINGING
            else -> CallMode.NONE
        }
    }
}