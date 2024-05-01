

import Combine
import SwiftHangeul
import UIKit

public enum AnimateHangeul {
    case start
    case progress(Character)
    case finish
}

open class AnimateTextLabel: AnimateTextType {
    public var _text: String? {
        get { self.label?.text
        }
        set {
            self.label?.text = newValue
            self.label?.superview?.layoutIfNeeded()
        }
    }
    
    public var isUserInteractionEnabled: Bool {
        get { label?.isUserInteractionEnabled ?? false }
        set { label?.isUserInteractionEnabled = newValue }
    }
    
    weak var label: UILabel?
    public var id: UUID = UUID()
    open var seconds: TimeInterval!
    open var animateText: String!
    open var defaultText: String!
    
    public var swiftHanguel: SwiftHangeul = SwiftHangeul()
    public var timerSubscriptions: AnyCancellable?
    public var animateTiming = PassthroughSubject<AnimateHangeul, Never>()
    
    deinit { timerSubscriptions = nil }
    
    public init(seconds: TimeInterval = 0.05,
                text: String,
                gesture enable: Bool = true)
    {
        self.seconds = seconds
        self.animateText = text
        self.defaultText = text
        applyAttribute(enable: enable)
    }
    
    public func setLabel(_ label: UILabel) {
        self.label = label
    }
    
    open func applyAttribute(enable: Bool) {
        self.label?.isUserInteractionEnabled = enable
    }
    
    public func cacheClear() {
        swiftHanguel.clear()
    }
    
    public func clear() {
        swiftHanguel.clear()
        self._text = ""
    }
}
