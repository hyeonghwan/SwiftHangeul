//
//  AnimateLabelController.swift
//  HanguelDemo
//
//  Created by 박형환 on 5/1/24.
//

import UIKit
import Combine
import SwiftHangeul
import CoreText


enum AnimateLabelTestCase: CaseIterable {
    
    static var allCases: [AnimateTextLabel] {
        [
            label1,
            label2,
            label3,
            label4,
            label5
        ]
    }
    
    static let test1: String = "헌법재판소에서 법률의 위헌결정, 탄핵의 결정, 정당해산의 결정 또는 헌법소원에 관한 인용결정을 할 때에는 재판관 6인 이상의 찬성이 있어야 한다."
    static let test2: String = "누구든지 체포 또는 구속을 당한 때에는 즉시 변호인의 조력을 받을 권리를 가진다."
    static let test3: String = "다만, 형사피고인이 스스로 변호인을 구할 수 없을 때에는 법률이 정하는 바에 의하여 국가가 변호인을 붙인다."
    static let test4: String = "대법원장은 국회의 동의를 얻어 대통령이 임명한다."
    static let test5: String = "모든 국민은 보건에 관하여 국가의 보호를 받는다. 대통령의 임기연장 또는 중임변경을 위한 헌법개정은 그 헌법개정 제안 당시의 대통령에 대하여는 효력이 없다."
    
    static let label1 = AnimateTextLabel.init(seconds: 0.1, text: test1 )
    static let label2 = AnimateTextLabel.init(seconds: 0.04, text: test2)
    static let label3 = AnimateTextLabel.init(seconds: 0.3, text: test3)
    static let label4 = AnimateTextLabel.init(seconds: 1, text: test4)
    static let label5 = AnimateTextLabel.init(seconds: 0.007, text: test5)
}

open class AnimateLabelController: UIViewController {
    
    private var animateTextTiming: AnimateTextTiming!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.estimatedRowHeight = 66
        table.rowHeight = UITableView.automaticDimension
        table.register(PreviewCell.self,
                       forCellReuseIdentifier: PreviewCell.identifier)
        return table
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting()
        addAutoLayout()
        applyAttributes()
    }
    
    deinit {
        animateTextTiming.reset()
    }
    
    private func initialSetting() {
        animateTextTiming = AnimateTextTiming(labels: [])
        animateTextTiming.append(labels: AnimateLabelTestCase.allCases)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func applyAttributes() {
        self.view.backgroundColor = .systemBackground
        animateTextTiming.gestureBinding()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.animateTextTiming.longPressGestureBinding()
            self?.animateTextTiming.gestureBinding()
        })
    }
    
    private func addAutoLayout() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension AnimateLabelController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

extension AnimateLabelController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        animateTextTiming.labels.count
    }
    
    public func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCell.identifier) as? PreviewCell,
            let label = animateTextTiming.labels[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.label.text = "\(String(describing: label.defaultText))"
        label.setLabel(cell.label)
        cell.label.isUserInteractionEnabled = true
        label.isUserInteractionEnabled = true
        
        Task { [weak self] in
            await self?.animateTextTiming.startAnimate(indexPath.row)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
