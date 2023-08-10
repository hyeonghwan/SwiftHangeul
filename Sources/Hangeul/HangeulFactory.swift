
//
//  HangeulFactory.swift
//
//  Created by 박형환 on 2023/02/01.
//

import Foundation

class HangeulFactory{
    
    static let base_code: Int = 0xAC00
    static let base_init_soundCode: Int = 0x1100 // ㄱ
    static let base_vowel_code: Int = 0x1161 // ㅏ
    
    static let last_code: Int = 0xD7A3
    
    static let initial_sounds: String = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ"
    
    static let middle_vowels: [String] = [ "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ",
                                        "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ",
                                        "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ" ]
    
    static let final_consonants: [String?] = [nil, "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ",
                                       "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ",
                                       "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ" ]
    
    init(){
        let k = HangeulFactory.getSingleLetter(HangeulFactory.getInitSoundCode(Character("ㄱ")))
        print("kfgagd : \(k)")
    }
    
    
    // 초성을 입력받아서 몇번째 글자인지 배열의 인덱스로 계산
    public static func getInitSoundCode(_ ch: Character) -> Int{
        
        if let index: String.Index = initial_sounds.firstIndex(of: ch){
            return initial_sounds.distance(from: initial_sounds.startIndex, to: index)
        }
        return -1
    }
    
    //중성은 이중 모음으로 만들 수도 있기 때문에 문자열을 입력인자로 받게 합시다.
    public static func getVowelCode(_ str: String) -> Int{
        let cnt: Int = middle_vowels.count
        
        for i in 0..<cnt{
            if middle_vowels[i] == str{
                return i
            }
        }
        return -1
    }
    
    //입력 - 한글 중성 문자
    public static func getVowelCode(_ ch: Character) -> Int{
        return getVowelCode(String(ch))
    }
    
    
    //종성은 이중으로 만들 수도 있기 때문에 문자열을 입력인자로 받게 합시다.
    public static func getFinalConsonantCode(_ str: String) -> Int{
        let cnt: Int = final_consonants.count
        
        for i in 0..<cnt{
            if final_consonants[i] == str{
                return i
            }
        }
        return -1
    }
    
    //입력 - 한글 종성 문자
    public static func getFinalConsonantCode(_ ch: Character?) -> Int{
        if let ch = ch {
            return getFinalConsonantCode(String(ch))
        }
        return getFinalConsonantCode(String(""))
        
    }
    
    
    //자음 하나로 만들어진 한글 문자를 만드는 메서드
    public static func getSingleLetter(_ value: Int) -> Character?{
        
        if let scalar = Unicode.Scalar(HangeulFactory.base_init_soundCode + value){
        
            return Character(scalar)
        }
        return nil
    }
    
    //모음 하나로 만들어진 한글 문자를 만드는 메서드
    public static func getSingleVowel(_ value: Int) -> Character?{
        
        if let scalar = Unicode.Scalar(HangeulFactory.base_vowel_code + value){
            return Character(scalar)
        }
        return nil
    }

    // 초성 중성 종성으로 한글자 만들기
    public static func getComplteLetter(_ init_sound: Int ,_ vowel: Int,_ final: Int) -> Character?{
        var tempFinalConsonant: Int = 0
        if final >= 0{
            tempFinalConsonant = final
        }
        let 중성개수 = middle_vowels.count
        let 종성개수 = final_consonants.count
        let base_code = HangeulFactory.base_code
        
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
    public static func 글자_분해_함수(input string: String) -> [Character]{
    
        var result: [Character] = []
        for scalar in string.unicodeScalars{
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
    public static func getComplteCode(_ init_sound: Int ,_ vowel: Int,_ final: Int) -> Int{
        
        var tempFinalConsonant: Int = 0
        if final >= 0{
            tempFinalConsonant = final
        }
        let 중성개수 = middle_vowels.count
        let 종성개수 = final_consonants.count
        let base_code = HangeulFactory.base_code
        
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
    public static func isDoubleFinalConsonant(_ ch: Character?) -> Bool{
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
    public static func isDoubleVowel(_ ch: Character) -> Bool{
        let code = getVowelCode(ch)
        return enable_이중모음(code)
    }
}


extension HangeulFactory{
    static func enable_이중모음(_ code: Int) -> Bool{
        return (code == 8) || (code == 13) || (code == 17) || (code == 18)
    }
    
    static func enable_이중종성(_ code: Int) -> Bool {
        return code == 1 || code == 4 || code == 8 || code == 17
    }
    
    static func isInitSound(_ ch: Character) -> Bool{
        return getInitSoundCode(ch) != -1
    }
    static func isVowel(_ ch: Character) -> Bool{
        return getVowelCode(ch) != -1
    }
    static func isCharKey(_ ch: Character) -> Bool{
        return ch.isLetter
    }
    static func isFinalConsonant(_ ch: Character) -> Bool{
        return getFinalConsonantCode(ch) != -1
    }
}

extension HangeulFactory{
    static func checkIsDoublejongSung(_ str: String) -> String{
        if str.length <= 1{
            return str
        }
        if str.length == 2{
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
    static func checkIsDoubleVowel(_ str: String) -> String{
        if str.length <= 1{
            return str
        }
        
        if str.length == 2{
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


