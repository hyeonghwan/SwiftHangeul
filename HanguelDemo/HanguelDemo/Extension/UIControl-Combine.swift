


import UIKit
import Combine


extension UIControl {
    func tapEvent() -> AnyPublisher<UIControl, Never> {
        EventPublisher(control: self, controlEvent: .touchUpInside)
            .eraseToAnyPublisher()
    }
}

extension UIControl {
    final class ControlSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Control {
        private var subscriber: S?
        private let control: Control
        
        init(subscriber: S, control: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action: #selector (eventHandler), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
        }
        @objc func eventHandler() {
            _ = subscriber?.receive(control)
        }
    }
}


extension UIControl {
    struct EventPublisher<Control: UIControl>: Publisher {
        typealias Output = Control
        typealias Failure = Never
        
        private let control: Control
        private let controlEvent: Control.Event
        
        init(control: Control, controlEvent: Control.Event) {
            self.control = control
            self.controlEvent = controlEvent
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
            let subscription = ControlSubscription(
                subscriber: subscriber,
                control: control,
                event: controlEvent
            )
            subscriber.receive(subscription: subscription)
        }
    }
}
