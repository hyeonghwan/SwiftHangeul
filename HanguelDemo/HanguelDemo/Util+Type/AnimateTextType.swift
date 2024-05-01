//
//  AnimateProtocol.swift
//  HanguelDemo
//
//  Created by 박형환 on 4/10/24.
//

import Foundation
import Combine
import SwiftHangeul

public protocol AnimateTextType: AnyObject {
    var id:                 UUID            { get set }
    var _text:              String?         { get set }
    var seconds:            TimeInterval!   { get set }
    var animateText:        String!         { get set }
    var defaultText:        String!         { get set }
    var swiftHanguel:       SwiftHangeul    { get set }
    var timerSubscriptions: AnyCancellable? { get set }
    
    func cacheClear()
    func clear()
    func cancel()
    func separateTiming(string: String)             -> Publishers.Sequence<[AnimateHangeul], Never>
    func separateTiming()                           -> Publishers.Sequence<[AnimateHangeul], Never>
    func animateStopAndPlay(current string: String) -> AnyPublisher<AnimateHangeul, Never>
    func animateTextStart()                         -> AnyPublisher<AnimateHangeul, Never>
}

public extension AnimateTextType {
    
    var gestureSubscription: AnyCancellable? { nil }
    var _text: String? { "" }
    func cacheClear() { }
    func clear() { }
    func cancel() {
        timerSubscriptions?.cancel()
        swiftHanguel.clear()
    }
    
    func separateTiming(string: String) -> Publishers.Sequence<[AnimateHangeul], Never> {
        let stringIndex = string.index(before: string.endIndex)
        let values = defaultText.suffix(from: stringIndex)
        return swiftHanguel
            .separate(input: String(values))
            .publisher
            .map { AnimateHangeul.progress($0) }
            .append([AnimateHangeul.finish])
    }
    
    func separateTiming() -> Publishers.Sequence<[AnimateHangeul], Never> {
        swiftHanguel
            .separate(input: defaultText)
            .publisher
            .map { AnimateHangeul.progress($0) }
            .prepend([AnimateHangeul.start])
            .append([AnimateHangeul.finish])
    }
    
    func animateStopAndPlay(current string: String) -> AnyPublisher<AnimateHangeul, Never> {
        cancel()
        let sequence = separateTiming(string: string)
        return animateText(sequence: sequence)
    }
    
    func animateTextStart() -> AnyPublisher<AnimateHangeul, Never> {
        cancel()
        let sequence = separateTiming()
        return animateText(sequence: sequence)
    }
    
    private func animateText(sequence: Publishers.Sequence<[AnimateHangeul], Never>) -> AnyPublisher<AnimateHangeul, Never> {
        let timer
        = Timer
            .publish(every: seconds, on: .main, in: .default)
            .autoconnect()
        
        let zip = Publishers.Zip(sequence, timer)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput:  { [weak self] tuple in
                let (animateEnum, _) = tuple
                if case let .progress(char) = animateEnum {
                    self?.swiftHanguel.input(char: char)
                }
            })
            .map(\.0)
            
        return zip.eraseToAnyPublisher()
    }
}
