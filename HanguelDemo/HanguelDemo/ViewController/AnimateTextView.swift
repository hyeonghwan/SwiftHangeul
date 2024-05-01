//
//  AnimateTextView.swift
//  HanguelDemo
//
//  Created by 박형환 on 5/1/24.
//

import SwiftHangeul
import UIKit

open class AnimateTextView: UITextView, AnimateTextType {
    public var id: UUID = UUID()
    open var seconds: TimeInterval!
    open var animateText: String!
    open var defaultText: String!
    
    public var swiftHanguel: SwiftHangeul = SwiftHangeul()
    public var timerSubscriptions: AnyCancellable?
    public var animateTiming = PassthroughSubject<AnimateHangeul, Never>()
    
    public convenience init(frame: CGRect = .zero,
                            seconds: TimeInterval = 0.05,
                            text: String  = "안녕하세요 저는 박형환 이라고 합니다.",
                            gesture enable: Bool = true)
    {
        self.init(frame: frame, textContainer: nil)
        self.seconds = seconds
        self.animateText = text
        self.defaultText = text
        applyAttribute(enable: enable)
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    open func applyAttribute(enable: Bool) {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.isUserInteractionEnabled = enable
        self.isEditable = false
    }
    
    public func cacheClear() {
        swiftHanguel.clear()
    }
    
    public func clear() {
        swiftHanguel.clear()
        self.text = ""
    }
}
