//
//  AnimateTiming-Protocol.swift
//  HanguelDemo
//
//  Created by 박형환 on 5/1/24.
//

import SwiftHangeul
import Foundation
import Combine

public protocol AnimateTiming: AnyObject {
    associatedtype View: AnimateTextType
    var labels:        [View]                    { get set }
    var ids:           [UUID]                    { get }
    var allTaskID:     UUID                      { get set }
    var taskList:      [UUID: Task<Void, Never>] { get set }
    var subscriptions: Set<AnyCancellable>       { get set }
    
    func gestureBinding()
    func reset()
    func append(labels: [some AnimateTextType])
    func append(label: some AnimateTextType)
    func animation(offset: Int)
    func ascendAnimation()
    func specificAnimation(numbers: [Int])
    func descendAnimation()
    
    func allStartAnimation() async
    func restart(id: UUID) async
    func startAnimation(labels: [some AnimateTextType], in_order: Bool) async
    func startAnimate(_ offset: Int) async
}

public extension AnimateTiming {
    var ids: [UUID] {
        self.labels.map(\.id)
    }
    
    func gestureBinding() { }
    
    func cancel(id: UUID) {
        taskList[id]?.cancel()
        labels.filter { $0.id == id }.first?.cacheClear()
    }
    
    func reset() {
        taskList[allTaskID]?.cancel()
        for (_, value) in taskList { value.cancel() }
        for label in labels { label.clear() }
    }
    
    func reset(id: UUID) {
        taskList[id]?.cancel()
        labels.filter { $0.id == id }.first?.clear()
    }
    
    func reset(offset: Int) {
        guard let label = labels[safe: offset] else {
            return
        }
        taskList[label.id]?.cancel()
        label.clear()
    }
    
    func append(label: some AnimateTextType) {
        assert(type(of: label) == Self.View.self)
        self.labels.append(label as! Self.View)
    }
    
    func append(labels: [some AnimateTextType]) {
        assert(type(of: labels) == [Self.View].self)
        self.labels.append(contentsOf: labels as! [Self.View])
    }
    
    func animation(offset: Int) {
        Task { await self.startAnimate(offset) }
    }
    
    func ascendAnimation() {
        taskList[allTaskID] = Task {
            for enumerated in self.labels.enumerated() {
                let (offset, _) = enumerated
                await self.startAnimate(offset)
            }
        }
    }
    
    func specificAnimation(numbers: [Int]) {
       taskList[allTaskID] = Task {
           for number in numbers {
               await self.startAnimate(number)
           }
       }
   }
    
    func descendAnimation() {
        taskList[allTaskID] = Task {
            for enumerated in self.labels.enumerated().reversed() {
                let (offset, _) = enumerated
                await self.startAnimate(offset)
            }
        }
    }
    
    @MainActor
    func allStartAnimation() async {
        await startAnimation(labels: labels, in_order: false)
    }
    
    @MainActor
    func startAnimation(labels: [some AnimateTextType],
                                in_order: Bool = true) async {
        labels.forEach { reset(id: $0.id) }
        for label in labels {
            taskList[label.id] = Task {
                let values = label.animateTextStart().values
                for await _ in values {
                    let text = label.swiftHanguel.getTotoal()
                    label._text = text
                }
            }
            if in_order { await taskList[label.id]?.value }
            label.cacheClear()
        }
    }
    
    @MainActor
    func restart(id: UUID) async {
        if let label = labels.filter({ $0.id == id }).first {
            if let text = label._text, text.isEmpty {
                return
            }
            taskList[label.id] = Task {
                let values = label.animateStopAndPlay(current: label._text ?? "").values
                var originalText = label._text
                originalText?.removeLast()
                for await _ in values {
                    let text = label.swiftHanguel.getTotoal()
                    let newText = (originalText ?? "") + text
                    label._text = newText
                }
            }
            label.cacheClear()
        }
    }
    
    @MainActor
    func startAnimate(_ offset: Int) async {
        if let label = labels[safe: offset] {
            await startAnimation(labels: [label], in_order: true)
        }
    }
}
