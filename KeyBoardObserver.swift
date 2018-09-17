import UIKit

public class KeyBoardObserver {
    
    public typealias Handler = (KeyBoradInfo) -> Void
    
    public enum Status {
        case willShow
        
        case didShow
        
        case willHide
        
        case didHide
        
        case willChangeFrame
        
        case didChangeFrame
    }
    
    public struct KeyBoradInfo {
        
        public private(set) var beginFrame: CGRect
        
        public private(set) var endFrame: CGRect
        
        public private(set) var animationDuration: TimeInterval
        
        public private(set) var animationCurve: UIViewAnimationCurve
        
        public private(set) var isLocal: Bool
        
        init?(userInfo: [AnyHashable: Any]) {
            guard let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
                let animationCurve = UIViewAnimationCurve(rawValue: curve),
                let isLocal = (userInfo[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue  else {
                return nil
            }
            self.beginFrame = beginFrame
            self.endFrame = endFrame
            self.animationDuration = animationDuration
            self.animationCurve = animationCurve
            self.isLocal = isLocal
        }
    }
    
    private var handlers: [Status: Handler] = [:]
    
    deinit {
        removeAllObserver()
    }
}

extension KeyBoardObserver.Status {
    
    var notificationName: Notification.Name {
        switch self {
        case .willShow:
            return .UIKeyboardWillShow
        case .didShow:
            return .UIKeyboardDidShow
        case .willHide:
            return .UIKeyboardWillHide
        case .didHide:
            return .UIKeyboardDidHide
        case .willChangeFrame:
            return .UIKeyboardWillChangeFrame
        case .didChangeFrame:
            return .UIKeyboardDidChangeFrame
        }
    }
    
    var selector: Selector {
        switch self {
        case .willShow:
            return #selector(KeyBoardObserver.keyBoardWillShow(_:))
        case .didShow:
            return #selector(KeyBoardObserver.keyBoardDidShow(_:))
        case .willHide:
            return #selector(KeyBoardObserver.keyBoardWillHide(_:))
        case .didHide:
            return #selector(KeyBoardObserver.keyBoardDidHide(_:))
        case .willChangeFrame:
            return #selector(KeyBoardObserver.keyBoardWillChangeFrame(_:))
        case .didChangeFrame:
            return #selector(KeyBoardObserver.keyBoardDidChanageFrame(_:))
        }
    }
}

extension KeyBoardObserver.KeyBoradInfo: CustomStringConvertible {
    
    public var description: String {
        let curveDescription: String = {
            switch animationCurve {
            case .easeInOut: return "UIViewAnimationCurve.easeInOut"
            case .easeIn: return "UIViewAnimationCurve.easeIn"
            case .easeOut: return "UIViewAnimationCurve.easeOut"
            case .linear: return "UIViewAnimationCurve.linear"
            }
        }()
        return "KeyBoradInfo(beginFrame: \(beginFrame); endFrame: \(endFrame); animationDuration: \(animationDuration); animationCurve: \(curveDescription); isLocal: \(isLocal))"
    }
}

extension KeyBoardObserver {
    
    @objc private func keyBoardWillShow(_ notification: Notification) {
        handle(notification: notification, with: .willShow)
    }
    
    @objc private func keyBoardDidShow(_ notification: Notification) {
        handle(notification: notification, with: .didShow)
    }
    
    @objc private func keyBoardWillHide(_ notification: Notification) {
        handle(notification: notification, with: .willHide)
    }
    
    @objc private func keyBoardDidHide(_ notification: Notification) {
        handle(notification: notification, with: .didHide)
    }
    
    @objc private func keyBoardWillChangeFrame(_ notification: Notification) {
        handle(notification: notification, with: .willChangeFrame)
    }
    
    @objc private func keyBoardDidChanageFrame(_ notification: Notification) {
        handle(notification: notification, with: .didChangeFrame)
    }
    
    private func handle(notification: Notification, with status: Status) {
        guard let userInfo = notification.userInfo, let info = KeyBoradInfo(userInfo: userInfo) else { return }
        handlers[status]?(info)
    }
}

extension KeyBoardObserver {
    
    func addObserver(status: Status, handler: @escaping Handler) {
        NotificationCenter.default.addObserver(self, selector: status.selector, name: status.notificationName, object: nil)
        handlers[status] = handler
    }
    
    func removeObserver(status: Status) {
        NotificationCenter.default.removeObserver(self, name: status.notificationName, object: nil)
        handlers[status] = nil
    }
    
    func removeAllObserver() {
        removeObserver(status: .willShow)
        removeObserver(status: .didShow)
        removeObserver(status: .willHide)
        removeObserver(status: .didHide)
        removeObserver(status: .didChangeFrame)
        removeObserver(status: .willChangeFrame)
        handlers = [:]
    }
}
