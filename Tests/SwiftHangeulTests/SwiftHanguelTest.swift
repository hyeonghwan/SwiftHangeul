//
//  File.swift
//  
//
//  Created by 박형환 on 3/10/24.
//

import XCTest
import Combine
@testable import Hangeul

final class SwiftHangeulTests: XCTestCase {
    
    var sut: SwiftHangeul!
    
    override func setUpWithError() throws {
        sut = SwiftHangeul.init()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInputCase() {
        sut.input("안녕하세요")
        sut.input(" 만나서 반갑습니다.")
        let result = sut.getTotoal()
        XCTAssertEqual("안녕하세요 만나서 반갑습니다.", result)
    }
    
    func testRemoveCase() {
        sut.input("안녕하세요")
        sut.input(" 만나서 반갑습니다.")
        sut.backKey()
        sut.backKey()
        sut.backKey()
        let result = sut.getTotoal()
        XCTAssertEqual("안녕하세요 만나서 반갑습니", result)
    }
    
    
    func testTimeCase() {
        
    }
}

