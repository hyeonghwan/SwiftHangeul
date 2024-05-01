//
//  UIView-Gesture.swift
//  HanguelDemo
//
//  Created by 박형환 on 4/10/24.
//

import UIKit
import Combine

extension UIView {
    func gesture(_ gestureType: AnimateTexts.GestureType = .tap()) -> AnimateTexts.GesturePublisher {
        AnimateTexts.GesturePublisher(
            view: self,
            gestureType: gestureType
        )
    }
}

enum AnimateTexts {
    final class GestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType {
        
        private var subscriber: S?
        private var gestureType: GestureType
        private var view: UIView
        init(subscriber: S, view: UIView, gestureType: GestureType) {
            self.subscriber = subscriber
            self.view = view
            self.gestureType = gestureType
            configureGesture(gestureType)
        }
        
        private func configureGesture(_ gestureType: GestureType) {
            let gesture = gestureType.get()
            gesture.addTarget(self, action: #selector(handler))
            view.addGestureRecognizer(gesture)
        }
        
        @objc func handler(_ sender: Any) {
            _ = subscriber?.receive(gestureType)
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
        }
    }

    struct GesturePublisher: Publisher {
        
        typealias Output = GestureType
        typealias Failure = Never
        
        private let view: UIView
        private let gestureType: GestureType
        
        init(view: UIView, gestureType: GestureType) {
            self.view = view
            self.gestureType = gestureType
        }
        func receive<S>(subscriber: S) where S : Subscriber,
        GesturePublisher.Failure == S.Failure, GesturePublisher.Output
        == S.Input {
            let subscription = GestureSubscription(
                subscriber: subscriber,
                view: view,
                gestureType: gestureType
            )
            subscriber.receive(subscription: subscription)
        }
    }

    enum GestureType {
        case tap(UITapGestureRecognizer = .init())
        case longPress(UILongPressGestureRecognizer = .init())
        
        func get() -> UIGestureRecognizer {
            switch self {
            case let .tap(tapGesture):
                return tapGesture
            case let .longPress(longPressGesture):
                return longPressGesture
           }
        }
    }
}
