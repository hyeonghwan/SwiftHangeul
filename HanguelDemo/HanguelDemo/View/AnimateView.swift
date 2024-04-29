//
//  AnimateView.swift
//  HanguelDemo
//
//  Created by 박형환 on 4/18/24.
//

import UIKit
import Combine
import SwiftHangeul

public class AnimateView: UIView, AnimateTextType {
    
    public var id: UUID = UUID()
    open var seconds: TimeInterval!
    
    open var animateText: String! {
        didSet {
             self.layer.setNeedsDisplay()
        }
    }
    
    var resultAnimateText: [String] = []
    var splitStrings: [String] = []
    var preCalculateTextSize: [Int: CGSize] = [:]
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
        
        defer {
            let font1 = UIFont.boldSystemFont(ofSize: 16)
            self.splitStrings = animateText.components(separatedBy: " ").map { String($0) }
            caculateTextSize(
                attributes: [.foregroundColor : UIColor.white.cgColor,.font : font1]
            )
            lineWidthHeighCaculate()
        }
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 12
        self.layer.contentsScale = 3
    }
    
    func lineWidthHeighCaculate() {
        preCalculateTextSize = resultAnimateText.enumerated().reduce(into: [Int: CGSize]()) { dic, tuple in
            let (key, value) = tuple
            dic[key] = (value as NSString).size(withAttributes: attributes)
        }
    }
    
    /// 최대 Width 길이만큼 가능한 문자열을 생성해줍니다.
    /// - Parameter attributes: attribute
    func caculateTextSize(attributes: [NSAttributedString.Key : Any]) {
        let widthMaximum = UIScreen.main.bounds.width - 100
        var width: CGFloat = 0
        var cnt: Int = 0
        var strs: [String] = []
        var temp: String = ""
        
        while splitStrings.count > cnt {
            strs.append(splitStrings[cnt])
            temp += splitStrings[cnt]
            if widthMaximum >= width {
                let size
                = (temp as NSString).size(withAttributes: attributes)
                width = size.width
            } else {
                strs.removeLast()
                resultAnimateText.append(strs.joined(separator: " "))
                width = 0
                temp = ""
                strs = []
                continue
            }
            cnt += 1
        }
        if !strs.isEmpty { resultAnimateText.append(strs.joined(separator: " ")) }
    }
    
    var textLineSize: CGSize = .init(width: 0, height: 0)
    
    /// 현재 display할 index
    var currentIndex: Int = 0
    
    /// 누적 count
    var acnt: Int = 0
    var beforeCnt: Int = 0
    
    var diffIndex: Range<Int> = 0..<1
    
    
    func reset() {
        currentIndex = 0
        acnt         = 0
        beforeCnt    = 0
        diffIndex    = 0..<1
    }
    
    lazy var defaultTextheight: CGFloat = ("안녕" as NSString).size(withAttributes: attributes).height
    let font1 = UIFont.boldSystemFont(ofSize: 16)
    lazy var attributes: [NSAttributedString.Key: Any] = [.foregroundColor : UIColor.white.cgColor, .font : font1]
    
    public override func draw(_ layer: CALayer, in ctx: CGContext) {
        let currentCnt = resultAnimateText[currentIndex].count + acnt
        if currentCnt < animateText.count && resultAnimateText.count - 1 > currentIndex {
            beforeCnt = acnt
            acnt += resultAnimateText[currentIndex].count
            currentIndex += 1
        }
        diffIndex = beforeCnt..<animateText.count
        
        ctx.clear(layer.visibleRect)
        
        ctx.setShouldSmoothFonts(true)
        ctx.setAllowsFontSmoothing(true)
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: bounds.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        textLineSize
        = drawText(context: ctx,
                   text: animateText,
                   attributes: attributes,
                   x: 10,
                   y: 10)
    }
    
    func drawText(context: CGContext, text: String, attributes: [NSAttributedString.Key : Any], x: CGFloat, y: CGFloat) -> CGSize {
        let font = attributes[.font] as! UIFont
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        let textSize = (text as NSString).size(withAttributes: attributes)
        
        let path = CGPath(rect:
                            CGRect(x: ceil(x),
                                   y: ceil(y + font.descender),
                                   width: ceil(textSize.width),
                                   height: ceil(textSize.height)),
                          transform: nil)
        let textPath    = path
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let frame       = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: attributedString.length), textPath, nil)
        context.setAllowsFontSubpixelPositioning(true)
            
        CTFrameDraw(frame, context)
        
        return textSize
    }
}


