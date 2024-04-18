//
//  File.swift
//  
//
//  Created by 박형환 on 3/20/24.
//

import Foundation

#if os(iOS)

#if canImport(UIKit)

import UIKit
import Combine

open class AnimateTextViewController: UIViewController {
    
    lazy var animateTextLabel: [AnimateTextLabel] = []
    
    public override func viewDidLoad() {
        animateTextLabel.append(AnimateTextLabel.init(text: "안녕하새요 저는 박형환 입니다."))
        animateTextLabel.append(AnimateTextLabel.init(text: "안녕하새요 저는 박형환 입니다."))
        animateTextLabel.append(AnimateTextLabel.init(text: "안녕하새요 저는 박형환 입니다."))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateTextLabel.forEach { $0.animateTextStart() }
    }
}

public class AnimateTextLabel: UILabel {
    private var seconds: TimeInterval!
    private var animateText: String!
    private var defaultText: String!
    private var swiftHanguel: SwiftHangeul = SwiftHangeul()
    private var timerSubscriptions: AnyCancellable?
    
    public convenience init(frame: CGRect = .zero,
                            seconds: TimeInterval = 0.3,
                            text: String)
    {
        self.init(frame: frame)
        self.seconds = seconds
        self.animateText = text
        self.defaultText = text
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    public func applyAttribute() {
        
    }
    
    public func animateTextStart() {
        timerSubscriptions?.cancel()
        
        let separted = swiftHanguel.separate(input: defaultText)
        
        let timer
        = Timer
            .publish(every: seconds, on: .main, in: .default)
            .autoconnect()
        
        timerSubscriptions = Publishers.Zip(separted.publisher, timer)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput:  { [weak self] tuple in
                let letter: Character = tuple.0
                self?.swiftHanguel.input(char: letter)
            })
            .compactMap { [weak self] _ in self?.swiftHanguel.getTotoal() }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] text in
                self?.text = text
            })
    }
}

#endif
#endif
