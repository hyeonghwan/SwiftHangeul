



import UIKit
import Combine
import SwiftHangeul

open class AnimateTextViewController: UIViewController {
    
    private var animateTextTiming: AnimateTextTiming!
    private let stackView = UIStackView()
    private let refreshButton = UIButton()
    private var subscriptions = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        applyAttributes()
        addAutoLayout()
        binding()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateTextTiming.descendAnimation()
    }
    
    
    private func binding() {
        refreshButton.tapEvent()
            .sink(receiveValue: { [weak self] _ in
                self?.animateTextTiming.specificAnimation(numbers: [0,1,2,3].shuffled())
            }).store(in: &subscriptions)
    }
    
    private func applyAttributes() {
        animateTextTiming = AnimateTextTiming(labels: [])
        let label = AnimateTextLabel.init(text: "안녕하십니까 *** 이라고 합니다. \n 안녕하십니까 *** 이라고 합니다. \n 안녕하십니까 *** 이라고 합니다.")
        label.numberOfLines = 0
        let label2 = AnimateTextLabel.init(text: "안녕하십니까 박혀왛 이라고 하빈다..")
        let label3 = AnimateTextLabel.init(text: "ㅋㅋㅋㅇㄹㅁㄴㅇㄹ.")
        let label4 = AnimateTextLabel.init(text: "테스트 메시지 입니다..")
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        animateTextTiming.append(label: label)
        animateTextTiming.append(label: label2)
        animateTextTiming.append(label: label3)
        animateTextTiming.append(label: label4)
        self.view.backgroundColor = .white
        
        animateTextTiming.labels.forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .black
            $0.minimumScaleFactor = 0.6
            $0.adjustsFontSizeToFitWidth = true
        }
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
    }
    
    private func addAutoLayout() {
        view.addSubview(stackView)
        view.addSubview(refreshButton)
        animateTextTiming.labels.forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .systemPink
        
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12),
            refreshButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 44),
            refreshButton.heightAnchor.constraint(equalToConstant: 44),
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
