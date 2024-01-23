package com.kardenvan.call_mode

enum class CallMode {
    RINGING,
    NONE,
    IN_PROGRESS;

    
    override fun toString(): String {
        return when (this) {
            RINGING -> "ringing"
            NONE -> "none"
            IN_PROGRESS -> "inProgress"
        }
    }
}