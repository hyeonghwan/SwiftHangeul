

import Combine
import SwiftHangeul
import UIKit

public enum AnimateHangeul {
    case start
    case progress(Character)
    case finish
}

open class AnimateTextLabel: UILabel, AnimateTextType {
    public var id: UUID = UUID()
    open var seconds: TimeInterval!
    open var animateText: String!
    open var defaultText: String!
    
    public var swiftHanguel: SwiftHangeul = SwiftHangeul()
    public var timerSubscriptions: AnyCancellable?
    public var animateTiming = PassthroughSubject<AnimateHangeul, Never>()
    
    public convenience init(frame: CGRect = .zero,
                            seconds: TimeInterval = 0.05,
                            text: String,
                            gesture enable: Bool = true)
    {
        self.init(frame: frame)
        self.seconds = seconds
        self.animateText = text
        self.defaultText = text
        applyAttribute(enable: enable)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    open func applyAttribute(enable: Bool) {
        self.numberOfLines = 0
        self.isUserInteractionEnabled = enable
    }
    
    public func cacheClear() {
        swiftHanguel.clear()
    }
    
    public func clear() {
        swiftHanguel.clear()
        self.text = ""
    }
}
