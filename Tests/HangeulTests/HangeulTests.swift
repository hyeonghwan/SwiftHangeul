import XCTest
@testable import Hangeul

final class HangeulTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    //UNIcodeScalar 와 UTF8
    func testUnicode(){
        
        let 글자 = "한글놀이"
        for i in 글자.unicodeScalars{
            print(i.value)
        }
        
        for k in 글자.utf8{
            print(k)
        }
        
        let arr = HangeulFactory.글자_분해_함수(input: "그러면 이것도 분해 가능 하냐?")
        let arr1 = HangeulFactory.글자_분해_함수(input: "한영!")
        let one = arr.map{ String($0)}
        let two = arr1.map{ String($0) }
        let oneResult = ["ㄱ","ㅡ","ㄹ","ㅓ","ㅁ","ㅕ","ㄴ"," ",
                         "ㅇ","ㅣ","ㄱ","ㅓ","ㅅ","ㄷ", "ㅗ", " ",
                         "ㅂ", "ㅜ", "ㄴ", "ㅎ", "ㅐ", " ",
                         "ㄱ", "ㅏ","ㄴ","ㅡ","ㅇ"," ",
                         "ㅎ", "ㅏ", "ㄴ", "ㅑ", "?"]
        let twoResult = ["ㅎ","ㅏ","ㄴ","ㅇ","ㅕ","ㅇ","!"]
        XCTAssertEqual(one, oneResult,"fail One 분해 실패")
        XCTAssertEqual(two, twoResult, "fail two 분해 실패")
    }

    func makeHangeul(choSung: Character, jungSung: Character, jongSung: Character )
    -> Character?{
        // given
        let 초성코드 = HangeulFactory.getInitSoundCode(choSung)
        let 중성코드 = HangeulFactory.getVowelCode(jungSung)
        let 종성코드 = HangeulFactory.getFinalConsonantCode(jongSung)

        // when
        if let 글자 = HangeulFactory.getComplteLetter(초성코드, 중성코드, 종성코드){
            return 글자
        }
        return nil
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
            hangeul.inputLetter(char)
            print(hangeul.getTotalString())
        }
        string2.forEach { char in
            hangeul.inputLetter(char)
            print(hangeul.getTotalString())
        }
        string3.forEach { char in
            hangeul.inputLetter(char)
            print(hangeul.getTotalString())
        }
        
        let result = hangeul.getTotalString()
        //Then
        XCTAssertEqual("한글 한 글하글", result, "한글입력 \(result) 테스트 실패")
    }
}
