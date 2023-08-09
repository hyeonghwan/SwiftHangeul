// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  Hangule.swift
//
//  Created by 박형환 on 2023/02/02.
//

import Foundation


class Hangule{
    
    private var hangeulState: HanguleState
    
    private var source: String
    
    public init(){
        self.hangeulState = HanguleState()
        self.source = ""
    }
    
    //결과 문자열 얻기
    public func getTotalString() -> String{
        return source
    }
    
    // 글자 입력 상태 초기화
    private func resetState() {
        hangeulState.hangule_init()
    }
    
    public func inputLetter(_ ch: String?){
        // '\b' remove Key
        if (ch == nil){
            removeKeyPressed()
            return
        }
        guard let char = ch else { return }
        var ch = Character(char)
        
        if let value = ch.unicodeScalars.first?.value{
            // 문자가 영어거나 letter가 아닐경우 문자열에 추가 후
            // 초성 을 기대하는 상태로 초기화
            if (((value >= 97) && (value <= 122)) || ((value >= 65) && (value <= 90))) || (!ch.isLetter){
                source += String(ch)
                hangeulState.hangule_init()
                return
            }
        }
        
        switch hangeulState.state{
        case .초성_Turn:
            inputInitSoundProc(ch: ch)
            break
        case .중성모음_Turn:
            inputVowelProc(ch: ch)
            break
        case .종성_Turn:
            inputFinalConsonantProc(ch: ch)
            break
        case .none:
            fatalError("error occur")
        }
    }
    
    public func inputLetter(_ ch: Character?){
        // '\b' remove Key
        if (ch == nil){
            removeKeyPressed()
            return
        }
        guard let ch = ch else { return }
        
        if let value = ch.unicodeScalars.first?.value{
            // 문자가 영어거나 letter가 아닐경우 문자열에 추가 후
            // 초성 을 기대하는 상태로 초기화
            if (((value >= 97) && (value <= 122)) || ((value >= 65) && (value <= 90))) || (!ch.isLetter){
                source += String(ch)
                hangeulState.hangule_init()
                return
            }
        }
        
        switch hangeulState.state{
        case .초성_Turn:
            inputInitSoundProc(ch: ch)
            break
        case .중성모음_Turn:
            inputVowelProc(ch: ch)
            break
        case .종성_Turn:
            inputFinalConsonantProc(ch: ch)
            break
        case .none:
            fatalError("error occur")
        }
    }
    
//    private func inputNoKorea(ch: Character){
//        resetState()
//        source += String(ch)
//    }
    
    private func inputInitSoundProc(ch: Character){
        if (!hangeulState.inputAtInitSound(ref: &source, ch: ch)){
            inputLetter(ch)
        }
    }
    
    private func inputVowelProc(ch: Character){
        if (hangeulState.existVowel() == false){
            if hangeulState.inputFirstVowel(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }else{
            if hangeulState.inputSecondVowel(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }
    }
    
    private func inputFinalConsonantProc(ch: Character){
        if hangeulState.첫번째_종성_존재_여부_함수() == false{
            if hangeulState.inputFirstFinalConsonant(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }else{
            if hangeulState.inputSecondFinalConsonant(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }
    }
    
    private func removeKeyPressed(){
        if source.length <= 0 {
            return
        }
        
        if hangeulState.state == .초성_Turn || hangeulState.isInitSound(){
            
            hangeulState.setStateInitSound()
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            return
        }
        
        if hangeulState.isSingleVowel(){
            hangeulState.setStateVowel()
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            source += String(hangeulState.초성코드_글자로_변환_함수())
            return
        }
        
        if hangeulState.isDoubleVowel(){
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            
            hangeulState.마지막_중성_모음_지우기_함수()
            source += String(hangeulState.getCompleteChar())
            return
        }
        
        if hangeulState.isSingleFinalConsonant(){
            hangeulState.종성_지우기_함수()
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            source += String(hangeulState.getCompleteChar())
            return
        }else if hangeulState.isFull(){
            hangeulState.마지막_종성_지우기_함수()
            let index = source.index(source.startIndex, offsetBy: source.length - 1)
            source = String(source[..<index])
            source += String(hangeulState.getCompleteChar())
        }
    }
}
