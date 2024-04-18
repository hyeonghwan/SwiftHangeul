import XCTest
@testable import SwiftHangeul

final class HangeulTests: XCTestCase {
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
        func solution(_ s:String) -> String {
            s.components(separatedBy: [" "]).map {
                let v = $0.first!.uppercased()
                if $0.count == 1 { return v }
                var str = $0
                _ = str.removeFirst()
                return v + String(str.map { k in String(k.lowercased())}.joined())
            }.joined(separator: " ")
        }
    }
    
    //UNIcodeScalar 와 UTF8
    func testUnicode() {
        let arr = HangeulFactory.shared.글자_분해_함수(input: "그러면 이것도 분해 가능 하냐?")
        let arr1 = HangeulFactory.shared.글자_분해_함수(input: "한영!")
        let one = arr.map{ String($0) }
        let two = arr1.map{ String($0) }
        
        let one_pair: [String] = ["ㄱ","ㅡ","ㄹ","ㅓ","ㅁ","ㅕ","ㄴ"," ",
                         "ㅇ","ㅣ","ㄱ","ㅓ","ㅅ","ㄷ", "ㅗ", " ",
                         "ㅂ", "ㅜ", "ㄴ", "ㅎ", "ㅐ", " ",
                         "ㄱ", "ㅏ","ㄴ","ㅡ","ㅇ"," ",
                         "ㅎ", "ㅏ", "ㄴ", "ㅑ", "?"]
        let two_pair: [String] = ["ㅎ","ㅏ","ㄴ","ㅇ","ㅕ","ㅇ","!"]
        
        let hangeul1 = Hangule()
        let hangeul2 = Hangule()
        let hangeul3 = Hangule()
        let hangeul4 = Hangule()
        
        one.forEach { str in
            hangeul1.insert(str)
        }
        let result_one = hangeul1.getTotalString()
        
        two.forEach { str in
            hangeul2.insert(str)
        }
        let result_two = hangeul2.getTotalString()
        
        one_pair.forEach { str in
            hangeul3.insert(str)
        }
        let result_one_pair = hangeul3.getTotalString()
        
        two_pair.forEach { str in
            hangeul4.insert(str)
        }
        let result_two_pair = hangeul4.getTotalString()
        
        XCTAssertEqual(result_one, result_one_pair,"fail One 분해 실패")
        XCTAssertEqual(result_two, result_two_pair, "fail two 분해 실패")
    }

    func makeHangeul(choSung: Character, jungSung: Character, jongSung: Character )
    -> Character?{
        // given
        let 초성코드 = HangeulFactory.shared.getInitSoundCode(choSung)
        let 중성코드 = HangeulFactory.shared.getVowelCode(jungSung)
        let 종성코드 = HangeulFactory.shared.getFinalConsonantCode(jongSung)

        // when
        if let 글자 = HangeulFactory.shared.getComplteLetter(초성코드, 중성코드, 종성코드){
            return 글자
        }
        return nil
    }
    
    func test더블종성() {
        //given
        let arr: [String] = ["ㄱ", "ㅏ", "ㅂ" , "ㅅ"]
        
        let hanguel = Hangule()
        arr.forEach { char in
            hanguel.insert(char)
        }
        
        XCTAssertEqual(hanguel.getTotalString(), "값")
        
        hanguel.inputLetter(nil)
        hanguel.inputLetter("ㅅ")
        
        XCTAssertEqual(hanguel.getTotalString(), "값")
    }
    
    func testCase한글(){
        //given
        let 초: Character = "ㄱ"
        let 중: Character = "ㅏ"
        let 종: Character = "ㄴ"
        //when
        let 한글자 = makeHangeul(choSung: 초, jungSung: 중, jongSung: 종)
    
        //then
        XCTAssertEqual("간", String(한글자!), "this 글자 -> 간 실패")
    }
    
    func testCase한글여러글자(){
        //given
        let 초: Character = "ㄱ"
        let 중: Character = "ㅏ"
        let 종: Character = "ㄴ"
        
        let 초1: Character = "ㅎ"
        let 중1: Character = "ㅏ"
        let 종1: Character = "ㄴ"
        //when
        let 한글자 = makeHangeul(choSung: 초, jungSung: 중, jongSung: 종)
        let 한글자1 = makeHangeul(choSung: 초1, jungSung: 중1, jongSung: 종1)
        let multi = String(한글자!) + String(한글자1!)
        //then
        XCTAssertEqual("간", String(한글자!), "this 글자 -> 간 실패")
        XCTAssertEqual("한", String(한글자1!), "'한' 글자변환 실패")
        XCTAssertEqual("간한", multi, "'간한' 글자변환 실패")
    }
    
    
    func testCase한글입력함수(){
        //given
        let hangeul = Hangule()
        let string1: [String?] = ["ㅎ", "ㅏ", "ㄴ", "ㄱ","ㅡ", "ㄹ", " "]
        let string2: [String?] = ["ㅎ", "ㅏ", "ㄴ"," ", "ㄱ","ㅡ", "ㄹ"]
        let string3: [String?] = ["ㅎ", "ㅏ", "ㄴ",nil, "ㄱ","ㅡ", "ㄹ"]
        
        //when
        string1.forEach{ char in
            hangeul.insert(char)
            print(hangeul.getTotalString())
        }
        string2.forEach { char in
            hangeul.insert(char)
            print(hangeul.getTotalString())
        }
        string3.forEach { char in
            hangeul.insert(char)
            print(hangeul.getTotalString())
        }
        
        let result = hangeul.getTotalString()
        //Then
        XCTAssertEqual("한글 한 글하글", result, "한글입력 \(result) 테스트 실패")
    }
}

