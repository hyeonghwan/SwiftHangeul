//
//  PreviewCell.swift
//  HanguelDemo
//
//  Created by 박형환 on 5/1/24.
//

import UIKit

final class PreviewCell: UITableViewCell, CellIdentifier {
    
    private lazy var height = containerView.heightAnchor.constraint(equalToConstant: 200)
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    deinit {
        print("cell deinit")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    func addAutoLayout() {
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchor = label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12)
        
        let leadingAnchor =  label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12)
        
        let trailingAnchor = label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12)
        
        let bottomAnchor = label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12)
        
        NSLayoutConstraint.activate([topAnchor,leadingAnchor,trailingAnchor,bottomAnchor])
    }
    
    
}

