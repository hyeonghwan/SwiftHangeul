

import UIKit
import Combine
import SwiftHangeul
import CoreText

open class AnimateTextViewController: UIViewController {
    
    let text1 = """
    1. View 의 레이아웃을 적용하고 이미지를 디코딩 후 2.Commit Transaction 으로 부터 받은 Package를 분석하고 deserialize하여 rendering tree에 보낸다 1.View 의 레이아웃을 적용하고 이미지를 디코딩 후 2.Commit Transaction 으로 부터 받은 Package를 분석하고 deserialize하여 rendering tree에 보낸다 1.View 의 레이아웃을 적용하고 이미지를 디코딩 후 2.Commit Transaction 으로 부터 받은 Package를 분석하고 deserialize하여 rendering tree에 보낸다 1.View 의 레이아웃을 적용하고 이미지를 디코딩 후 2.Commit Transaction 으로 부터 받은 Package를 분석하고 deserialize하여 rendering tree에 보낸다
    """
    
    private var animateTextViewTiming: AnimateTextViewTiming!
    private var animateTextTiming: AnimateTextTiming!
    private var animateTiming: AnimateViewTiming!
    
    private let stackView = UIStackView()
    private let uilabel = UILabel()
    private let refreshButton = UIButton()
    private lazy var animateView = AnimateView.init(text: text1)
    private lazy var uiTextView = AnimateTextView.init(text: text1)
    private var subscriptions = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        applyAttributes()
        addAutoLayout()
        binding()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { await animateTextViewTiming.startAnimate(0) }
    }
    
    private func binding() {
        refreshButton.tapEvent()
            .sink(receiveValue: { [weak self] _ in
                Task { await self?.animateTextViewTiming.startAnimate(0) }
            }).store(in: &subscriptions)
    }
    
    private func applyAttributes() {
        uiTextView.textColor = .white
        uiTextView.backgroundColor = .black
        uiTextView.font = UIFont.boldSystemFont(ofSize: 16)
        uilabel.textColor = .white
        uilabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        animateTextViewTiming = AnimateTextViewTiming.init(uiTextView)
        animateTextTiming = AnimateTextTiming(labels: [])
        animateTiming = AnimateViewTiming(animateView)
        
        let label = AnimateTextLabel.init(text: "안녕하십니까 *** 이라고 합니다.")
        label.numberOfLines = 0
        let label2 = AnimateTextLabel.init(text: "\(text1)")
        let label3 = AnimateTextLabel.init(text: "ㅋㅋㅋㅇㄹㅁㄴㅇㄹ.")
        let label4 = AnimateTextLabel.init(text: "테스트 메시지 입니다..")
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        animateTextTiming.append(label: label2)

        
        animateTextTiming.gestureBinding()
        self.view.backgroundColor = .black
        animateTextTiming.labels.forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .black
            $0.minimumScaleFactor = 0.6
            $0.adjustsFontSizeToFitWidth = true
        }
        
        uilabel.text = text1
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        uiTextView.layer.borderColor = UIColor.white.cgColor
        uiTextView.layer.borderWidth = 1
        uiTextView.layer.cornerRadius = 6
    }
    
    private func addAutoLayout() {
        view.addSubview(uiTextView)
        view.addSubview(refreshButton)
        view.addSubview(uilabel)
        
        animateTextTiming.labels.forEach { stackView.addArrangedSubview($0) }
        
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        uiTextView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .systemPink
        
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12),
            refreshButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 44),
            refreshButton.heightAnchor.constraint(equalToConstant: 44),
            uilabel.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 12),
            uilabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            
            uiTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            uiTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            uiTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            uiTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
}
