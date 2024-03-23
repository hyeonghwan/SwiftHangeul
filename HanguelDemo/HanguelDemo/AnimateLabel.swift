

import Combine
import SwiftHangeul
import UIKit


extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public class AnimateTextTiming {
    public var labels: [AnimateTextLabel]
    public var ids: [UUID]
    public var task: Task<Void, Never>?
    
    public init(labels: [AnimateTextLabel]) {
        self.labels = labels
        self.ids = labels.map(\.id)
    }
    
    public func append(label: AnimateTextLabel) {
        self.labels.append(label)
        self.ids.append(label.id)
    }
    
    public func ascendAnimation() {
        labels.forEach { $0.clear() }
        task?.cancel()
        task = Task.detached {
            for enumerated in self.labels.enumerated() {
                let (offset, _) = enumerated
                await self.startAnimate(offset)
            }
        }
    }
    
    public func specificAnimation(numbers: [Int]) {
        labels.forEach { $0.clear() }
        task?.cancel()
        task = Task.detached {
            for n in numbers {
                await self.startAnimate(n)
            }
        }
    }
    
    public func descendAnimation() {
        labels.forEach { $0.clear() }
        task?.cancel()
        task = Task.detached {
            for enumerated in self.labels.enumerated().reversed() {
                let (offset, _) = enumerated
                await self.startAnimate(offset)
            }
        }
    }
    
    @MainActor
    public func startAnimate(_ offset: Int) async {
        if let label = labels[safe: offset] {
            let values = label.animateTextStart().values
            for await _ in values {
                let text = label.swiftHanguel.getTotoal()
                label.text = text
            }
        }
    }
}


public enum AnimateHangeul {
    case start
    case progress(Character)
    case finish
}


open class AnimateTextLabel: UILabel {
    public let id: UUID = UUID()
    open var seconds: TimeInterval!
    open var animateText: String!
    open var defaultText: String!
    
    public var swiftHanguel: SwiftHangeul = SwiftHangeul()
    public var timerSubscriptions: AnyCancellable?
    public var animateTiming = PassthroughSubject<AnimateHangeul, Never>()
    
    public convenience init(frame: CGRect = .zero,
                            seconds: TimeInterval = 0.05,
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
    
    public required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    open func applyAttribute() { }
    
    public func clear() {
        swiftHanguel.clear()
        self.text = ""
    }
    
    private func separateTiming() -> Publishers.Sequence<[AnimateHangeul], Never> {
        swiftHanguel
            .separate(input: defaultText)
            .publisher
            .map { AnimateHangeul.progress($0) }
            .prepend([AnimateHangeul.start])
            .append([AnimateHangeul.finish])
    }
    
    
    open func animateTextStart() -> AnyPublisher<AnimateHangeul, Never> {
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
