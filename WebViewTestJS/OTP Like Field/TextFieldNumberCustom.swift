//
//  TextFieldNumberCustom.swift
//  WebViewTestJS
//
//  Created by Rahul Vishwakarma  on 10/05/24.
//

import UIKit



///Take StackView in the storyboard and reference to the class with Leading or center top(Don't give width)
///and then outlet to Class.
///
///Intialization->
///let ontTexhObj = OneTextNumberTextField((textFieldStack: UIStackView, delegate: OneTextNumberTextFieldDelegate, numberOfField: 4)
///ontTexhObj.stackViewTextField()
///
///For clear Text-->ontTexhObj.clearText()


protocol OneTextNumberTextFieldDelegate: NSObject {
    func enteredAllValue(string: String)
    func isAllValueEnterd(flag: Bool)
}


class OneTextNumberTextField: NSObject {
        
    private weak var oneTextNumberDelegate: OneTextNumberTextFieldDelegate?
    private var numberOfField = 14
    private var textFieldWith = 25.0
    private var spacing = 2.0
    private var textFieldStack: UIStackView!
    
    
    required init(textFieldStack: UIStackView, delegate: OneTextNumberTextFieldDelegate, numberOfField: Int = 14, textFieldWith: CGFloat = 25.0, spacing: CGFloat = 2.0) {
        self.textFieldStack = textFieldStack
        self.oneTextNumberDelegate = delegate
        self.numberOfField = numberOfField
        self.spacing = spacing
        self.textFieldWith = textFieldWith

    }
    
    override init() {
        super.init()
    }
    
    
    func stackViewTextField(isShowKeyboard: Bool = true) {
       
        textFieldStack.axis = .horizontal
        textFieldStack.distribution = .fill
        textFieldStack.spacing = spacing
        
        
        for i in 0...numberOfField-1 {
            let textfield = StackTextFieldSquare()
        
            textfield.backPressed = { [weak self] in

                guard let self = self else { return }
                for textFields in textFieldStack.subviews {
                    if textfield == textFields {

                        if (textFields as? UITextField)?.text == "" {
                            if (textFields.tag - 1) > (-1) {
                                (textFieldStack.subviews[textFields.tag - 1] as? UITextField)?.text = ""
                                textFieldStack.subviews[textFields.tag - 1].becomeFirstResponder()
                                return
                            }
                        } else {
                            textfield.text = ""
                            return
                        }
                    }
                }
                textfield.resignFirstResponder()
            }
            
            textfield.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: textfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: textFieldWith).isActive = true
            textfield.tag = i
            textfield.keyboardType = .numberPad
            textfield.delegate = self
            textfield.textAlignment = .center
            textfield.font = UIFont.systemFont(ofSize: 12)
            textfield.layer.borderColor = UIColor.gray.cgColor
            textfield.layer.borderWidth = 0.5
            textfield.layer.cornerRadius = 4
            textfield.clipsToBounds = true
            textFieldStack.addArrangedSubview(textfield)
        }
        
        if isShowKeyboard {
            if let textF = textFieldStack.subviews[0] as? UITextField {
                textF.becomeFirstResponder()
            }
        }
        
    }
    
    func clearText() {
        
        for textField in textFieldStack.subviews  {
            if let textField = (textField as? UITextField) {
                textField.text = ""
            }
        }
    }
}


extension OneTextNumberTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        let newLength = (textField.text ?? "").count + string.count - range.length
        
        if string == numberFiltered {
            
            if !string.isEmpty && newLength == 1 {
                textField.text = string
                
            } else if string.isEmpty || newLength > 1 {
                
                let oldString = textField.text ?? ""
                textField.text = string
                
                for textFields in textFieldStack.subviews {
                    
                    if textField == textFields {
                        
                        if oldString != "" && string != "" {
                            if textFields.tag + 1 < textFieldStack.subviews.count {
                                textFieldStack.subviews[textFields.tag + 1].becomeFirstResponder()
                                return false
                            }
                            
                        } else {
                            if textFields.tag - 1 > -1 {
                                textFieldStack.subviews[textFields.tag - 1].becomeFirstResponder()
                                return false
                            }
                            
                        }
                    }
                }
                textField.resignFirstResponder()
                return false
            }
            
            if newLength == 1 {
                for textFields in textFieldStack.subviews {
                    
                    if textField == textFields {
                        
                        if textFields.tag + 1 < textFieldStack.subviews.count {
                            textFieldStack.subviews[textFields.tag + 1].becomeFirstResponder()
                            return true
                        }
                    }
                }
                textField.resignFirstResponder()
            }
        }
        return string == numberFiltered
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var allText = ""
        for textFields in textFieldStack.subviews {
            allText = "\(allText)\((textFields as? UITextField)?.text ?? "")"
        }
        if allText.count == numberOfField {
            oneTextNumberDelegate?.enteredAllValue(string: allText)
            oneTextNumberDelegate?.isAllValueEnterd(flag: true)
        } else {
            oneTextNumberDelegate?.isAllValueEnterd(flag: false)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let point = CGPoint(x: textField.bounds.maxX, y: textField.bounds.height / 2)
        if let textPosition = textField.closestPosition(to: point) {
            textField.selectedTextRange = textField.textRange(from: textPosition, to: textPosition)
        }
    }
}

class StackTextFieldSquare: UITextField {

    var backPressed:(()->()) = {}

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func deleteBackward() {
        super.deleteBackward()
        backPressed()
    }

}
