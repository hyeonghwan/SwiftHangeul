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
    
    public init(factory: HangeulFactory = .shared, hanguelState: Hangule = Hangule()) {
        self.factory = factory
        self.hanguelState = hanguelState
    }
    
    public var length: Int {
        hanguelState.source.count
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
