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
    
    public func reset() {
        taskList[allTaskID]??.cancel()
        for (_, value) in taskList { value?.cancel() }
        for label in labels { label.clear() }
    }
    
    public func append(label: AnimateTextLabel) {
        self.labels.append(label)
        self.ids.append(label.id)
    }
    
    public func animation(offset: Int) {
        Task { await self.startAnimate(offset) }
    }
    
    public func ascendAnimation() {
        taskList[allTaskID]??.cancel()
        reset()
        taskList[allTaskID] = Task {
            for enumerated in self.labels.enumerated() {
                let (offset, _) = enumerated
                await self.startAnimate(offset)
            }
        }
    }
    
    public func specificAnimation(numbers: [Int]) {
        reset()
        taskList[allTaskID] = Task {
            for number in numbers {
                await self.startAnimate(number)
            }
        }
    }
    
    public func descendAnimation() {
        reset()
        taskList[allTaskID] = Task {
            for enumerated in self.labels.enumerated().reversed() {
                let (offset, label) = enumerated
                await self.startAnimate(offset)
            }
        }
    }
    
    @MainActor
    public func startAnimate(_ offset: Int) async {
        if let label = labels[safe: offset] {
            label.clear()
            taskList[label.id]??.cancel()
            taskList[label.id] = Task {
                let values = label.animateTextStart().values
                for await _ in values {
                    let text = label.swiftHanguel.getTotoal()
                    label.text = text
                }
            }
            await taskList[label.id]??.value
            label.cacheClear()
        }
    }
}
