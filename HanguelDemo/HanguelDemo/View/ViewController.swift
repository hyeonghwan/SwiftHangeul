//
//  ViewController.swift
//  HanguelDeom
//
//  Created by 박형환 on 3/23/24.
//

import UIKit


final class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 100
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild()
    }
    
    private func addChild() {
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr: [AnimationViewType] = AnimationViewType.allCases
        guard let type = arr[safe: indexPath.row] else {
            return
        }
        
        switch type {
        case .label:
            let vc = AnimateLabelController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .textView:
            let vc = AnimateTextViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default: break
        }
        return
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AnimationViewType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let arr: [AnimationViewType] = AnimationViewType.allCases
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell,
            let type = arr[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.apply(text: type.description)
        
        return cell
    }
}
