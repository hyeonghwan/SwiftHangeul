
//
//  HangeulFactory.swift
//
//  Created by 박형환 on 2023/02/01.
//

import Foundation

public final class HangeulFactory {
    
    
    public static let shared = HangeulFactory()
    
    let base_code: Int = 0xAC00
    let base_init_soundCode: Int = 0x1100 // ㄱ
    let base_vowel_code: Int = 0x1161 // ㅏ
    
    let last_code: Int = 0xD7A3
    
    
    let initial_sounds: [String] = [
        "\u{1100}","\u{1101}","\u{1102}","\u{1103}","\u{1104}",
        "\u{1105}","\u{1106}","\u{1107}","\u{1108}","\u{1109}",
        "\u{110A}","\u{110B}","\u{110C}","\u{110D}","\u{110E}",
        "\u{110F}","\u{1110}","\u{1111}","\u{1112}"
    ]
    
    var hangeulMap: [String: String]
    = [
        "\u{3131}": "ᄀ", "\u{3132}": "ᄁ", "\u{3134}": "ᄂ",
        "\u{3137}": "ᄃ", "\u{3138}": "ᄄ", "\u{3139}": "ᄅ",
        "\u{3141}": "ᄆ", "\u{3142}": "ᄇ", "\u{3143}": "ᄈ",
        "\u{3145}": "ᄉ", "\u{3146}": "ᄊ", "\u{3147}": "ᄋ",
        "\u{3148}": "ᄌ", "\u{3149}": "ᄍ", "\u{314A}": "ᄎ",
        "\u{314B}": "ᄏ", "\u{314C}": "ᄐ", "\u{314D}": "ᄑ",
        "\u{314E}" : "ᄒ",
        
        "\u{314F}": "ᅡ", "\u{3150}": "ᅢ", "\u{3151}": "ᅣ",
        "\u{3152}": "ᅤ", "\u{3153}": "ᅥ", "\u{3154}": "ᅦ",
        "\u{3155}": "ᅧ", "\u{3156}": "ᅨ", "\u{3157}": "ᅩ",
        "\u{3158}": "ᅪ", "\u{3159}": "ᅫ", "\u{315A}": "ᅬ",
        "\u{315B}": "ᅭ", "\u{315C}": "ᅮ", "\u{315D}": "ᅯ",
        "\u{315E}": "ᅰ", "\u{315F}": "ᅱ", "\u{3160}": "ᅲ",
        "\u{3161}": "ᅳ", "\u{3162}": "ᅴ", "\u{3163}": "ᅵ"
    ]
    
    let initial_sound호환: [String] = [
        "ᄀ", "ᄁ", "ᄂ", "ᄃ", "ᄄ", "ᄅ", "ᄆ","ᄇ", "ᄈ", "ᄉ", "ᄊ", "ᄋ", "ᄌ", "ᄍ","ᄎ", "ᄏ", "ᄐ", "ᄑ", "ᄒ" ]
    
     let middle_vowel호환: [String] =  [
        "ᅡ", "ᅢ", "ᅣ", "ᅤ", "ᅥ", "ᅦ", "ᅧ",
        "ᅨ", "ᅩ", "ᅪ", "ᅫ", "ᅬ", "ᅭ", "ᅮ",
        "ᅯ", "ᅰ", "ᅱ", "ᅲ", "ᅳ", "ᅴ", "ᅵ"
    ]
    
    
    let middle_vowels: [String] = [ "\u{1161}", "\u{1162}", "\u{1163}", "\u{1164}",
                                    "\u{1165}", "\u{1166}", "\u{1167}", "\u{1168}",
                                    "\u{1169}", "\u{116A}", "\u{116B}", "\u{116C}",
                                    "\u{116D}", "\u{116E}","\u{116F}", "\u{1170}",
                                    "\u{1171}", "\u{1172}", "\u{1173}", "\u{1174}", "\u{1175}"]
    
    let final_consonants:[String?] = [nil, "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ",
                                      "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ",
                                      "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ" ]
    

    /// 호환자모 한글을 -> 한글자모로 바꾸는 함수 입니다.
    /// - Parameter char: \u3131 : "ㄱ"
    /// - Returns:\u1100 "ㄱ"
    public func 한글호환자모_한글자모로_바꾸기(char: Character) -> String {
        return hangeulMap[String(char)] ?? String(char)
    }
    
    
    // 초성을 입력받아서 몇번째 글자인지 배열의 인덱스로 계산
    public func getInitSoundCode(_ ch: Character) -> Int {
        let character = 한글호환자모_한글자모로_바꾸기(char: ch)
        if let index = initial_sound호환.firstIndex(of: character) {
            return index
        }
        
        return -1
    }
    
    //중성은 이중 모음으로 만들 수도 있기 때문에 문자열을 입력인자로 받게 합니다.
    public func getVowelCode(_ str: String) -> Int {
        let cnt: Int = middle_vowel호환.count
        if str.count >= 2 { return -1 }
        let convertedString = 한글호환자모_한글자모로_바꾸기(char: Character(str))
        
        for i in 0..<cnt {
           if middle_vowel호환[i] == convertedString {
                return i
            }
        }
        return -1
    }
    
    //입력 - 한글 중성 문자
    public func getVowelCode(_ ch: Character) -> Int {
        return getVowelCode(String(ch))
    }
    
    
    //종성은 이중으로 만들 수도 있기 때문에 문자열을 입력인자로 받게 합시다.
    public func getFinalConsonantCode(_ str: String) -> Int{
        let cnt: Int = final_consonants.count
        
        for i in 0..<cnt{
            if final_consonants[i] == str{
                return i
            }
        }
        return -1
    }
    
    //입력 - 한글 종성 문자
    public func getFinalConsonantCode(_ ch: Character?) -> Int{
        if let ch = ch {
            return getFinalConsonantCode(String(ch))
        }
        return getFinalConsonantCode(String(""))
        
    }
    
    
    //자음 하나로 만들어진 한글 문자를 만드는 메서드
    public func getSingleLetter(_ value: Int) -> Character?{
        if let scalar = Unicode.Scalar(base_init_soundCode + value) {
        
            return Character(scalar)
        }
        return nil
    }
    
    //모음 하나로 만들어진 한글 문자를 만드는 메서드
    public func getSingleVowel(_ value: Int) -> Character?{
        if let scalar = Unicode.Scalar(base_vowel_code + value) {
            return Character(scalar)
        }
        return nil
    }

    // 초성 중성 종성으로 한글자 만들기
    public func getComplteLetter(_ init_sound: Int ,_ vowel: Int,_ final: Int) -> Character? {
        var tempFinalConsonant: Int = 0
        if final >= 0{
            tempFinalConsonant = final
        }
        let 중성개수 = middle_vowel호환.count
        let 종성개수 = final_consonants.count
        let base_code = base_code
        
        let completeChar: Int = base_code + init_sound * 중성개수 * 종성개수 + vowel * 종성개수 + tempFinalConsonant
        guard let scalar: Unicode.Scalar = Unicode.Scalar(completeChar) else {return nil}
        return Character(scalar)
        
    }
    
    /// '한' -> ㅎ,ㅏ,ㄴ 글자 분해
    /// - Parameter 코드: '한' 의 유니코드
    /// - Returns: ㅎ,ㅏ,ㄴ
    /// - 글자코드 를 (21 * 28) 로 나눈 몫은 초성
    /// - 글자코드를 (21 * 28)로 나눈 나머지를 , 28로 나눈 몫은 중성
    /// - 글자코드값을 28로 나눈 나머지는 종성
    public func 글자_분해_함수(input string: String) -> [Character] {
        var result: [Character] = []
        for scalar in string.unicodeScalars {
            let 코드 = Int(scalar.value)
            
            if !((코드 >= base_code) && (코드 <= last_code)){
                result.append(Character(String(scalar)))
            }else{
                let 인덱스_코드 = 코드 - base_code
                let 초성_코드 = 인덱스_코드 / (21 * 28)
                let 중성_코드 = (인덱스_코드 % (21 * 28)) / 28
                let 종성_코드 = 인덱스_코드 % 28

                if let 초성 = getSingleLetter(초성_코드){
                    result.append(초성)
                }

                if let 중성 = getSingleVowel(중성_코드){
                    result.append(중성)
                }

                if let 종성 = final_consonants[종성_코드]{
                    result.append(Character(종성))
                }
            }
        }
        return result
    }
    
    // 초성 중성 종성으로 한글자 만들기
    public func getComplteCode(_ init_sound: Int ,_ vowel: Int,_ final: Int) -> Int {
        
        var tempFinalConsonant: Int = 0
        if final >= 0{
            tempFinalConsonant = final
        }
        let 중성개수 = middle_vowel호환.count
        let 종성개수 = final_consonants.count
        let base_code = base_code
        
        let completeChar: Int = base_code + init_sound * 중성개수 * 종성개수 + vowel * 종성개수 + tempFinalConsonant
        return completeChar   
    }

    
    /// 이중 받침이 가능한 문자
    /// - Parameter ch: 종성 턴에 오는 문자가 이중 받침이 가능한지 판단하는 함수
    /// - Returns: 가능여부 Bool
    /// ㄱ,ㄴ,ㄹ,ㅂ 이중 받침  , 인덱스 -> 1, 4, 8, 17
    /// ㄱ -> ㄲ, ㄱㅅ
    /// ㄴ ->  앉, 않
    /// ㄹ -> , 닭, 닮, 닯, 앐, 앑, 앒, 앓
    /// ㅂ -> 앖
    /// 종성중에 이중 받침이 가능한 문자는 ㄱ,ㄴ,ㄹ,ㅂ
    public func isDoubleFinalConsonant(_ ch: Character?) -> Bool {
        let code = getFinalConsonantCode(ch)
        return enable_이중종성(code)
    }
    
    
    
    /// 이중 모음 가능여부를 판별하는 함수
    /// - Parameter ch: 중성 턴에 오는 문자가 이중 모음이 가능한지 판단하는 함수
    /// - Returns: 이중 모음 가능여부
    ///  ㅗ, ㅜ, ㅠ, ㅡ 이중 모음 가능    , 인덱스 -> 8 , 13, 17, 18
    ///  ㅠ   ->   ㅠㅣ  ->   ㅝ
    ///  ㅗ   ->    ㅘ,  ㅙ
    ///  ㅜ  ->    ㅝ,  ㅞ,  ㅟ.
    ///  ㅡ   ->    ㅢ
    public func isDoubleVowel(_ ch: Character) -> Bool {
        let code = getVowelCode(ch)
        return enable_이중모음(code)
    }
}


extension HangeulFactory{
    func enable_이중모음(_ code: Int) -> Bool{
        return (code == 8) || (code == 13) || (code == 17) || (code == 18)
    }
    
    func enable_이중종성(_ code: Int) -> Bool {
        return code == 1 || code == 4 || code == 8 || code == 17
    }
    
    func isInitSound(_ ch: Character) -> Bool {
        return getInitSoundCode(ch) != -1
    }
    
    func isVowel(_ ch: Character) -> Bool {
        return getVowelCode(ch) != -1
    }
    
    func isCharKey(_ ch: Character) -> Bool {
        return ch.isLetter
    }
    
    func isFinalConsonant(_ ch: Character) -> Bool {
        return getFinalConsonantCode(ch) != -1
    }
}

extension HangeulFactory{
    func checkIsDoublejongSung(_ str: String) -> String {
        if str.length <= 1 {
            return str
        }
        if str.length == 2 {
            switch str{
            case "ㄱㅅ":
                return "ㄳ"
            case "ㄴㅈ":
                return "ㄵ"
            case "ㄹㄱ":
                return "ㄺ"
            case "ㄹㅁ":
                return "ㄻ"
            case "ㄹㅂ":
                return "ㄼ"
            case "ㄹㅅ":
                return "ㄽ"
            case "ㄹㅌ":
                return "ㄾ"
            case "ㄹㅍ":
                return "ㄿ"
            case "ㄹㅎ":
                return "ㅀ"
            case "ㅂㅅ":
                return "ㅄ"
            default:
                break
            }
        }
        return str
    }
    
    func checkIsDoubleVowel(_ str: String) -> String {
        if str.length <= 1 {
            return str
        }
        
        if str.length == 2 {
            switch str{
            case "ㅗㅏ":
                return "ㅘ"
            case "ㅗㅐ":
                return "ㅙ"
            case "ㅗㅣ":
                return "ㅚ"
            case "ㅜㅓ":
                return "ㅝ"
            case "ㅜㅔ":
                return "ㅞ"
            case "ㅜㅣ":
                return "ㅟ"
            case "ㅡㅣ":
                return "ㅢ"
            case "ㅠㅣ":
                return "ㅝ"
            default:
                break
            }
        }
        return str
    }
}


