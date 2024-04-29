//
//  File.swift
//  
//
//  Created by 박형환 on 3/18/24.
//

import Foundation

internal struct InsertPosition {
    var start: Int
    var length: Int
    
    init(start: Int, length: Int) {
        self.start = start
        self.length = length
    }
    
    mutating func clear() {
        self.start = -1
        self.length = 0
    }
    
    func isNewInsertion(_ range: NSRange) -> Bool {
        isMiddleInsertion(range) || isPreInsertion(range) || isPostInsertion(range)
    }
    
    private func isMiddleInsertion(_ range: NSRange) -> Bool {
        range.location > start && (start + length) > (range.location + range.length)
    }
    
    private func isPreInsertion(_ range: NSRange) -> Bool {
        range.location < start
    }
    
    private func isPostInsertion(_ range: NSRange) -> Bool {
        (range.location + range.length) > (start + length)
    }
}
