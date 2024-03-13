//
//  File 3.swift
//  
//
//  Created by 박형환 on 2023/08/10.
//

import Foundation

public extension String {
    var length: Int {
        self.utf16.count
    }
    
    static var emptyStr: String {
        ""
    }
    
    subscript(range utf16: Range<String.Index>) -> String {
         String(self[utf16])
    }
}
