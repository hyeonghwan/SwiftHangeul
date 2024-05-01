//
//  TableViewCell.swift
//  HanguelDeom
//
//  Created by 박형환 on 3/23/24.
//

import UIKit


protocol CellIdentifier { }

extension CellIdentifier {
    var identifier: String {
        String(describing: Self.self)
    }
}

final class TableViewCell: UITableViewCell, CellIdentifier {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
}
