//
//  AnimateTiming.swift
//  HanguelDemo
//
//  Created by 박형환 on 4/10/24.
//

import UIKit
import Combine

public class AnimateViewTiming {
    private weak var view: AnimateView!
    public var subscriptions = Set<AnyCancellable>()
    var textViewAnimating: Task<Void, Never>?
    
    public init(_ textView: AnimateView) {
        self.view = textView
    }
    
    public func replace(textView: AnimateView) {
        self.view = textView
    }
    
    @MainActor
    public func startAnimate(_ offset: Int) async {
        view.animateText = ""
        textViewAnimating?.cancel()
        view.reset()
        textViewAnimating = Task {
            let values = view.animateTextStart().values
            for await _ in values {
                let text = view.swiftHanguel.getTotoal()
                view.animateText = text
            }
        }
    }
}


public class AnimateTextViewTiming {
    private weak var textView: AnimateTextView!
    public var subscriptions = Set<AnyCancellable>()
    var textViewAnimating: Task<Void, Never>?
    
    public init(_ textView: AnimateTextView) {
        self.textView = textView
    }
    
    public func replace(textView: AnimateTextView) {
        self.textView = textView
    }
    
    @MainActor
    public func startAnimate(_ offset: Int) async {
        textView.text = ""
        textViewAnimating?.cancel()
        textViewAnimating = Task {
            let values = textView.animateTextStart().values
            for await _ in values {
                let text = textView.swiftHanguel.getTotoal()
                textView.text = text
            }
        }
        textView.cacheClear()
    }
    
}

public class AnimateTextTiming {
    public var labels: [AnimateTextLabel]
    public var ids: [UUID]
    public var taskList: [UUID: Task<Void, Never>?] = [:]
    public var subscriptions = Set<AnyCancellable>()
    public var allTaskID = UUID()
    
    public init(labels: [AnimateTextLabel]) {
        self.labels = labels
        self.ids = labels.map(\.id)
    }
    
    public func gestureBinding() {
        labels.enumerated().forEach { value in
            if value.element.isUserInteractionEnabled {
                value.element.gesture()
                    .sink(receiveValue: { tap in
                        Task { [weak self] in
                            guard let self else { return }
                            await self.startAnimate(value.offset)
                        }
                    })
                    .store(in: &subscriptions)
            }
        }
    }
}
