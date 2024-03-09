//
//  File 3.swift
//  
//
//  Created by 박형환 on 2023/08/10.
//

import Foundation


extension String{
    var length: Int {
        self.utf16.count
    }
    
    static var emptyStr: String {
        ""
    }
}
