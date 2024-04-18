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
    var id: UUID { get set }
    var seconds: TimeInterval! { get set }
    var animateText: String! { get set }
    var defaultText: String! { get set }
    var swiftHanguel: SwiftHangeul { get set }
    var timerSubscriptions: AnyCancellable? { get set }
}

public extension AnimateTextType {
    
    var gestureSubscription: AnyCancellable? { nil }
    
    func cancel() {
        timerSubscriptions?.cancel()
        swiftHanguel.clear()
    }
    
    func separateTiming() -> Publishers.Sequence<[AnimateHangeul], Never> {
        swiftHanguel
            .separate(input: defaultText)
            .publisher
            .map { AnimateHangeul.progress($0) }
            .prepend([AnimateHangeul.start])
            .append([AnimateHangeul.finish])
    }
    
    func animateTextStart() -> AnyPublisher<AnimateHangeul, Never> {
        swiftHanguel.clear()
        
        let sequence = separateTiming()
        
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
