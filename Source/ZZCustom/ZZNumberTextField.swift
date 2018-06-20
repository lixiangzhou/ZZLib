//
//  ZZNumberTextField.swift
//  ZZLib
//
//  Created by lixiangzhou on 2018/6/20.
//  Copyright © 2018年 lixiangzhou. All rights reserved.
//

import UIKit

class ZZNumberTextField: UITextField, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Prop
    /// 分隔模式，例如银行卡号[4, 4, 4, 4, 4, 4]; 身份证号[6, 8, 4]
    var sepMode = [Int]() {
        didSet {
            var index = 0
            for mode in sepMode {
                index += mode
                sepIndex.append(index)
                index += 1
            }
        }
    }
    
    /// 长度限制，不包含空格的长度
    var lengthLimit = Int.max
    
    /// 要包含的其他的字符，默认包含 CharacterSet.decimalDigits 和 " "
    var additionIncludeCharacterSet: CharacterSet?
    
    // MARK: - Private Prop
    private var sepIndex = [Int]()
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text ?? ""
        let emptyCharacter = Character(" ")
        if range.length > 0 && string.isEmpty { // 删除
            if sepMode.count > 0 {
                if range.length == 1 {  // 删除一位
                    // 光标前第二个字符，如果是空格需要删除
                    var toDeleteCharacterEmpty: Character?
                    if range.location >= 1 {
                        toDeleteCharacterEmpty = text[text.index(text.startIndex, offsetBy: range.location - 1)]
                    }
                    
                    if range.location == text.count - 1 {   // 在最后删除
                        if toDeleteCharacterEmpty == emptyCharacter {
                            // 有空格，需要再往前删除一个空格
                            textField.deleteBackward()
                        }
                        return true
                    } else {    // 在中间删除
                        // 删除光标所在位置的字符
                        textField.deleteBackward()
                        
                        var offset = range.location
                        if toDeleteCharacterEmpty == emptyCharacter {
                            // 如果光标前有空格，删除
                            textField.deleteBackward()
                            offset -= 1
                        }
                        textField.text = formatToModeString(textField.text!)
                        resetPosition(offset: offset)
                        return false
                    }
                } else if range.length > 1 {
                    textField.deleteBackward()
                    textField.text = formatToModeString(textField.text!)
                    
                    var location = range.location
                    
                    var characterBeforeLocation: Character?
                    if location >= 1 {
                        characterBeforeLocation = text[text.index(text.startIndex, offsetBy: location - 1)]
                        if characterBeforeLocation == emptyCharacter {
                            location -= 1
                        }
                    }
                    
                    if NSMaxRange(range) != text.count {    // 光标不是在最后
                        resetPosition(offset: location)
                    }
                    
                    return false
                } else {
                    return true
                }
            } else {
                return true
            }
        } else if string.count > 0 {    // 输入文字
            if sepMode.count > 0 {
                if (text + string).replacingOccurrences(of: " ", with: "").count > lengthLimit {   // 超过限制
                    // 异步主线程是为了避免复制粘贴时光标错位的问题
                    DispatchQueue.main.async {
                        self.resetPosition(offset: range.location)
                    }
                    return false
                }
                
                var newSet = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: " "))
                if let additionIncludeCharacterSet = additionIncludeCharacterSet {
                    newSet = newSet.union(additionIncludeCharacterSet)
                }
                
                if string.trimmingCharacters(in: newSet).count > 0 {    // 不是数字
                    // 异步主线程是为了避免复制粘贴时光标错位的问题
                    DispatchQueue.main.async {
                        self.resetPosition(offset: range.location)
                    }
                    return false
                }
                
                let stringBeforeCursor = String(text[text.startIndex..<text.index(text.startIndex, offsetBy: range.location)])
                
                textField.insertText(string)
                textField.text = formatToModeString(textField.text!)
                
                let temp = stringBeforeCursor + string
                let newLocation = formatToModeString(temp).count
                
                // 异步主线程是为了避免复制粘贴时光标错位的问题
                DispatchQueue.main.async {
                    self.resetPosition(offset: newLocation)
                }
                return false
            } else {
                text += string
                if text.replacingOccurrences(of: " ", with: "").count > lengthLimit {
                    return false
                }
            }
        }
        return true
    }
    
    // MARK: - Private Method
    private func formatToModeString(_ text: String) -> String {
        var string = text.replacingOccurrences(of: " ", with: "")
        for index in sepIndex {
            if string.count > index {
                string.insert(" ", at: string.index(string.startIndex, offsetBy: index))
            }
        }
        return string
    }
    
    private func resetPosition(offset: Int) {
        let newPosition = self.position(from: self.beginningOfDocument, offset: offset)!
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }
}
