// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation


public final class Hangule {
    
    private var state: HangeulState
    
    private(set) var source: [Character]
    
    public init() {
        self.state = HangeulState()
        self.source = []
    }
    
    /// 결과 문자열 얻기
    public var total: String {
        String(source)
    }
    
    public func getCharList() -> [Character] {
        source
    }
    
    public func getTotalString() -> String {
        return total
    }
    
    internal func clear() {
        self.source = []
        resetState()
    }
    
    // 글자 입력 상태 초기화
    private func resetState() {
        state.stateInit()
    }
    
    
    public func insert(_ range: NSRange,_ ch: [Character]) {
        ch.reversed().forEach { char in
            source.insert(char, at: range.location)
        }
    }
    
    public func remove(_ location: Int, _ length: Int) {
        source.removeSubrange(location..<(location + length))
    }
    
    public func insert(_ ch: String?) {
        // '\b' remove Key
        if (ch == nil){
            removeAction()
            return
        }
        guard let char = ch else { return }
        let ch = Character(char)
        
        if let value = ch.unicodeScalars.first?.value {
            // 문자가 영어거나 letter가 아닐경우 문자열에 추가 후
            // 초성 을 기대하는 상태로 초기화
            if (((value >= 97) && (value <= 122)) || ((value >= 65) && (value <= 90))) || (!ch.isLetter) {
                source += String(ch)
                state.stateInit()
                return
            }
        }
        
        switch state.state {
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
        // remove Key
        if (ch == nil) {
            removeAction()
            return
        }
        guard let ch = ch else { return }
        
        if let value = ch.unicodeScalars.first?.value {
            // 문자가 영어거나 letter가 아닐경우 문자열에 추가 후
            // 초성 을 기대하는 상태로 초기화
            if (((value >= 97) && (value <= 122)) || ((value >= 65) && (value <= 90))) || (!ch.isLetter){
                source += String(ch)
                state.stateInit()
                return
            }
        }
        
        switch state.state {
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
    
    private func inputInitSoundProc(ch: Character){
        if (!state.inputAtInitSound(ref: &source, ch: ch)) {
            inputLetter(ch)
        }
    }
    
    private func inputVowelProc(ch: Character){
        if (state.existVowel() == false) {
            if state.inputFirstVowel(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        } else {
            if state.inputSecondVowel(ref: &source, ch: ch) == false{
                inputLetter(ch)
            }
        }
    }
    
    private func inputFinalConsonantProc(ch: Character) {
        if state.첫번째_종성_존재_여부_함수() == false {
            if state.inputFirstFinalConsonant(ref: &source, ch: ch) == false {
                inputLetter(ch)
            }
        } else {
            if state.inputSecondFinalConsonant(ref: &source, ch: ch) == false {
                inputLetter(ch)
            }
        }
    }
    
    private func removeAction() {
        if source.count <= 0 {
            return
        }
        
        if state.state == .초성_Turn || state.isInitSound() {
            state.setStateInitSound()
            source.removeLast()
            return
        }
        
        if state.isSingleVowel() {
            state.setStateVowel()
            source.removeLast()
            source += String(state.초성코드_글자로_변환_함수())
            return
        }
        
        if state.isDoubleVowel() {
            source.removeLast()
            state.마지막_중성_모음_지우기_함수()
            source += String(state.getCompleteChar())
            return
        }
        
        if state.isSingleFinalConsonant() {
            state.종성_지우기_함수()
            source.removeLast()
            source += String(state.getCompleteChar())
            return
        }else if state.isFull(){
            state.마지막_종성_지우기_함수()
            source.removeLast()
            source += String(state.getCompleteChar())
        }
    }
}
