//
//  TableViewCell.swift
//  HanguelDeom
//
//  Created by 박형환 on 3/23/24.
//

import UIKit


protocol CellIdentifier { }

extension CellIdentifier {
    static var identifier: String {
        String(describing: Self.self)
    }
}

final class TableViewCell: UITableViewCell, CellIdentifier {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    func apply(text: String) {
        self.label.text = text
    }
    
    private func addAutoLayout() {
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 20),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
