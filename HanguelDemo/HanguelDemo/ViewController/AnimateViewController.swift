//
//  AnimateViewController.swift
//  HanguelDemo
//
//  Created by 박형환 on 5/1/24.
//

import UIKit
import Combine
import SwiftHangeul
import CoreText


open class AnimateViewController: UIViewController {
    
    private var animateTiming: AnimateViewTiming!
    private lazy var animateView = AnimateView.init(text: text1)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        addAutoLayout()
    }
    
    func applyAttributes() {
        self.view.backgroundColor = .systemBackground
    }
    
    func addAutoLayout() {
        animateTiming = AnimateViewTiming(animateView)
    }
    
}
