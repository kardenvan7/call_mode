import Foundation
import CallKit

class CallModeListener {
    static private let defaultTimerIntervalMicroseconds: Int = 100000

    private var timerIntervalMicroseconds: Int = defaultTimerIntervalMicroseconds
    private var timer: Timer?
    private var callback: ((CallMode)->())?
    private var callMode: CallMode
    
    init() {
        self.callMode = CallModeListener.getCallModeInternal()
    }
    
    public func getCallMode() -> CallMode {
        return CallModeListener.getCallModeInternal()
    }
    
    func watch(callback: @escaping ((CallMode)->())) {
        self.callback = callback
        resetTimer()
    }

    func stopWatcher() {
        self.callback = nil
        stopAndRemoveTimer()
    }

    func setWatcherInterval(intervalInMicroseconds: Int) {
        timerIntervalMicroseconds = intervalInMicroseconds

        resetTimer()
    }

    private func resetTimer() {
        if (callback == nil) { return }

        stopAndRemoveTimer()

        timer = Timer.scheduledTimer(
            withTimeInterval: Double(timerIntervalMicroseconds / 1000000),
            repeats: true
        ) { timer in
            if (self.callback == nil) {
                self.stopAndRemoveTimer()
            }

            let newCallMode = self.getCallMode()
            
            if (self.callMode != newCallMode) {
                self.callMode = newCallMode
                self.callback?(newCallMode)
            }
        }
    }

    private func stopAndRemoveTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    static private func getCallModeInternal() -> CallMode {
        for call in CXCallObserver().calls {
            if !call.hasEnded {
                if call.hasConnected {
                    return CallMode.inProgress
                } else {
                    return CallMode.ringing
                }
            }
        }

        return CallMode.none
    }
}
