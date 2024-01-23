import Foundation

enum CallMode {
    case none
    case inProgress
    case ringing
    
    func toString() -> String {
        switch self {
        case .none:
            return  "none"
        case .inProgress:
            return "inProgress"
        case .ringing:
            return "ringing"
        }
     }
}
