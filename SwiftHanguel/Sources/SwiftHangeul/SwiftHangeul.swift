//
//  File 2.swift
//
//
//  Created by 박형환 on 2023/08/10.
//

#if os(iOS)

#if canImport(UIKit)

import UIKit

#endif

public final class SwiftHangeul {
    
    private var factory: HangeulFactory
    private var hanguelState: Hangule
    private var caculateState: Hangule
    private let debouncer: Debouncer
    private var insertPosition: InsertPosition
    
    public init(factory: HangeulFactory = .shared,
                hanguelState: Hangule = Hangule(),
                seconds: Int = 2) {
        self.factory = factory
        self.hanguelState = hanguelState
        self.debouncer = Debouncer(seconds: seconds)
        self.insertPosition = .init(start: -1, length: 0)
        self.caculateState = Hangule()
    }
    
    public var length: Int {
        hanguelState.source.count
    }
    
    private func delayClear() {
        debouncer.run { [weak self] in
            self?.caculateState.clear()
            self?.insertPosition.clear()
        }
    }
    
    public func input(char: Character?) {
        if let char
        {
            hanguelState.inputLetter(char)
        }
        else
        {
            hanguelState.inputLetter(nil)
        }
    }
    
    public func clear() {
        hanguelState.clear()
        caculateState.clear()
        insertPosition.clear()
    }
    
    public func input(_ str: String?) {
        if let str
        {
            let array = factory.글자_분해_함수(input: str)
            array.forEach { char in
                hanguelState.inputLetter(char)
            }
        }
        else
        {
            hanguelState.inputLetter(nil)
        }
    }
    
    public func insert(range: NSRange, _ str: String?) {
        delayClear()
        
        if str == nil {
            insertPosition.clear()
            caculateState.clear()
            hanguelState.remove(range.location, range.length)
            return
        }
        
        if insertPosition.isNewInsertion(range) {
            caculateState.clear()
            insertPosition.clear()
        }
        
        if insertPosition.start == -1 {
            insertPosition.start = range.location
        }
        
        let str = str!
        let separated = separate(input: str)
        
        separated.forEach { char in
            caculateState.inputLetter(char)
        }
        
        let insertionCharList = caculateState.getCharList()
        
        if range.length == 0
        {
            hanguelState.remove(insertPosition.start, insertPosition.length)
            hanguelState.insert(insertPosition.start, insertionCharList)
            insertPosition.length = insertionCharList.count
        }
        else
        {
            hanguelState.remove(insertPosition.start, range.length)
            hanguelState.insert(insertPosition.start, insertionCharList)
            insertPosition.clear()
        }
    }
    
    public func separate(input: String) -> [Character] {
        let array = factory.글자_분해_함수(input: input)
        return array.map { $0 }
    }
    
    public func backKey() {
        hanguelState.inputLetter(nil)
    }
    
    public func getTotoal() -> String {
        hanguelState.getTotalString()
    }
}

#endif
