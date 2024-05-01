

import UIKit
import Combine
import SwiftHangeul
import CoreText

let text1 = """
1. View 의 레이아웃을 적용하고 이미지를 디코딩 후 2.Commit Transaction 으로 부터 받은 Package를 분석하고 deserialize하여 rendering tree에 보낸다 1.View 의 레이아웃을 적용하고 이미지를 디코딩 후 2.Commit Transaction 으로 부터 받은 Package를 분석하고 deserialize하여 rendering tree에 보낸다 1.View 의 레이아웃을 적용하고 이미지를 디코딩 후 2.Commit Transaction 으로 부터 받은 Package를 분석하고 deserialize하여 rendering tree에 보낸다 1.View 의 레이아웃을 적용하고 이미지를 디코딩 후 2.Commit Transaction 으로 부터 받은 Package를 분석하고 deserialize하여 rendering tree에 보낸다
"""

open class AnimateTextViewController: UIViewController {
    
    private var animateTextViewTiming: AnimateTextViewTiming!
    
    private let uilabel = UILabel()
    private let refreshButton = UIButton()
    private lazy var uiTextView = AnimateTextView.init(text: text1)
    private var subscriptions = Set<AnyCancellable>()
    
    open override func viewDidLoad() {
        applyAttributes()
        addAutoLayout()
        binding()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { await animateTextViewTiming.startAnimate(0) }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.animateTextViewTiming.reset()
    }
    
    private func binding() {
        refreshButton.tapEvent()
            .sink(receiveValue: { [weak self] _ in
                Task { await self?.animateTextViewTiming.startAnimate(0) }
            }).store(in: &subscriptions)
    }
    
    private func applyAttributes() {
        uiTextView.textColor = .label
        uiTextView.backgroundColor = .systemBackground
        uiTextView.font = UIFont.boldSystemFont(ofSize: 16)
        uilabel.textColor = .label
        uilabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        animateTextViewTiming = AnimateTextViewTiming.init(uiTextView)
        
        self.view.backgroundColor = .systemBackground
        
        
        uilabel.text = text1
        uiTextView.layer.borderColor = UIColor.label.cgColor
        uiTextView.layer.borderWidth = 1
        uiTextView.layer.cornerRadius = 6
    }
    
    private func addAutoLayout() {
        view.addSubview(uiTextView)
        view.addSubview(refreshButton)
        
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        uiTextView.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .systemPink
        
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12),
            refreshButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 44),
            refreshButton.heightAnchor.constraint(equalToConstant: 44),
            
            uiTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            uiTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            uiTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            uiTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12)
        ])
    }
}

public class AnimateView: UIView, AnimateTextType {
    public var _text: String? 
    
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
                attributes: [.foregroundColor : UIColor.label.cgColor,.font : font1]
            )
            lineWidthHeighCaculate()
        }
        
        self.layer.borderColor = UIColor.label.cgColor
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
    lazy var attributes: [NSAttributedString.Key: Any] = [.foregroundColor : UIColor.label.cgColor, .font : font1]
    
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


