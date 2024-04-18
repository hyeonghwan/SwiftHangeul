//
//  Collection-safe.swift
//  HanguelDemo
//
//  Created by 박형환 on 4/10/24.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
