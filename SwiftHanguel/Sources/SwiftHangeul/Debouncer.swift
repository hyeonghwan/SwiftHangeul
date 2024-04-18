//
//  File.swift
//  
//
//  Created by 박형환 on 3/14/24.
//

import Foundation


public final class Debouncer {
    private var workItem: DispatchWorkItem?
    private let seconds: Int
    
    public init(seconds: Int) {
        self.seconds = seconds
    }
    
    public func run(_ closure: @escaping () -> ()) {
        self.workItem?.cancel()
        let newWork = DispatchWorkItem(block: closure)
        workItem = newWork
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(seconds), execute: newWork)
    }
}
