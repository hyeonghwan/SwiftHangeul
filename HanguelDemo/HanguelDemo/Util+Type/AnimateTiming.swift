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
    
    deinit { reset() }
    public func reset() { textViewAnimating?.cancel() }
    
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


public class AnimateTextViewTiming: AnimateTiming {
    
    public var labels: [AnimateTextView]
    public var allTaskID: UUID = UUID()
    public var taskList: [UUID : Task<Void, Never>] = [:]
    
    public typealias View = AnimateTextView
    
    private weak var textView: AnimateTextView!
    public var subscriptions = Set<AnyCancellable>()
    var textViewAnimating: Task<Void, Never>?
    
    public init(_ textView: AnimateTextView...) {
        self.labels = []
        self.textView = textView.first
        defer {
            textView.forEach { self.labels.append($0) }
        }
    }
    
    public func replace(textView: AnimateTextView) {
        self.textView = textView
    }
    
    deinit { reset() }
    
    public func reset() {
        textViewAnimating?.cancel()
        textView.cacheClear()
    }
}


public class AnimateTextTiming: AnimateTiming {
    
    public var labels:      [AnimateTextLabel]
    public var taskList:    [UUID: Task<Void, Never>] = [:]
    public var subscriptions = Set<AnyCancellable>()
    public var allTaskID     = UUID()
    
    public init(labels: [AnimateTextLabel]) {
        self.labels = labels
    }
    
    deinit {
        labels.forEach { $0.clear() }
        reset()
    }
    
    public func longPressGestureBinding() {
        labels.enumerated().forEach { value in
            if value.element.isUserInteractionEnabled {
                value.element.label?.gesture(.longPress(.init()))
                    .map { $0.get().state }
                    .sink(receiveValue: { [weak self] state in
                        guard let self else { return }
                        switch state {
                        case .began:
                            self.cancel(id: value.element.id)
                        case .ended:
                            Task { await self.restart(id: value.element.id) }
                        default: break
                        }
                    })
                    .store(in: &subscriptions)
            }
        }
    }
    
    public func gestureBinding() {
        labels.enumerated().forEach { value in
            if value.element.isUserInteractionEnabled {
                value.element.label?.gesture()
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
