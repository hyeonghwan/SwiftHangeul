//
//  File.swift
//  
//
//  Created by 박형환 on 3/10/24.
//

import XCTest
import Combine
@testable import SwiftHangeul

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
    
    func testInputAndBack() {
        sut.input("안녕하세요")
        sut.input(" 만나서 반갑습니다.")
        sut.backKey()
        sut.backKey()
        sut.backKey()
        let result = sut.getTotoal()
        XCTAssertEqual("안녕하세요 만나서 반갑습", result)
    }
    
    func testEmoji() {
        let ch1: [Character] = ["⚠️"]
        let ch2: [Character] = ["💡"]
        let ch3: [Character] = ["❌"]
        let ch4: [Character] = ["😇"]
        XCTAssertEqual(ch1.count, 1)
        XCTAssertEqual(ch2.count, 1)
        XCTAssertEqual(ch3.count, 1)
        XCTAssertEqual(ch4.count, 1)
    }
    
    let str =
"""
모든 국민은 자기의 행위가 아닌 친족의 행위로 인하여 불이익한 처우를 받지 아니한다. 국회의 회의는 공개한다. 다만, 출석의원 과반수의 찬성이 있거나 의장이 국가의 안전보장을 위하여 필요하다고 인정할 때에는 공개하지 아니할 수 있다. 모든 국민은 거주·이전의 자유를 가진다. 대통령은 전시·사변 또는 이에 준하는 국가비상사태에 있어서 병력으로써 군사상의 필요에 응하거나 공공의 안녕질서를 유지할 필요가 있을 때에는 법률이 정하는 바에 의하여 계엄을 선포할 수 있다. 모든 국민은 사생활의 비밀과 자유를 침해받지 아니한다. 모든 국민은 신체의 자유를 가진다. 누구든지 법률에 의하지 아니하고는 체포·구속·압수·수색 또는 심문을 받지 아니하며, 법률과 적법한 절차에 의하지 아니하고는 처벌·보안처분 또는 강제노역을 받지 아니한다.모든 국민은 보건에 관하여 국가의 보호를 받는다. 저작자·발명가·과학기술자와 예술가의 권리는 법률로써 보호한다. 모든 국민은 소급입법에 의하여 참정권의 제한을 받거나 재산권을 박탈당하지 아니한다. 정당은 그 목적·조직과 활동이 민주적이어야 하며, 국민의 정치적 의사형성에 참여하는데 필요한 조직을 가져야 한다. 대통령의 임기는 5년으로 하며, 중임할abs 수 없다. 국회는 법률에 저촉되지 아니하는 범위안에서 의사와 내부규율에 관한 규칙을 제정할 수 있다. 국민의 모든 자유와 권리는 국가안전보장·질서유지 또는 공공복리를 위하여 필요한 경우에 한하여 법률로써 제한할 수 있으며, 제한하는 경우에도 자유와 권리의 본질적인 내용을 침해할 수 없다.
"""
    
    func testRemoveCase() {
        measure {
            sut.input("\(str)")
        }
    }
    
    func testMeasure() {
        measure {
            _ = sut.separate(input: str)
        }
    }
}
