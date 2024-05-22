//
//  NewViewController.swift
//  WebViewTestJS
//
//  Created by WYH IOS  on 10/05/24.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var textFieldStack: UIStackView!
    
    var numberOfField = 14
    var heightWidhth = 25.0
    var spacing = 2.0
    
    var oneTextNumField: OneTextNumberTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oneTextNumField = OneTextNumberTextField(textFieldStack: textFieldStack, delegate: self)
        oneTextNumField?.stackViewTextField()
        
        //self.addAdvertVC()
        
        
       // AddAdvertiseView.shared.addSubView(parentView: self.view)
        
        
        
//        view.frame = CGRect(x: 50, y: 50, width: 300, height: 300)
//        self.view.addSubview(view)

        // addTextField()
        // Do any additional setup after loading the view\
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func addTextField() {
        
        textFieldStack.axis = .horizontal
        textFieldStack.distribution = .fill
        
        textFieldStack.spacing = spacing
        for i in 0...numberOfField-1 {
            let textfield = UITextField()
            textfield.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: textfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: heightWidhth).isActive = true
            textfield.tag = i
            textfield.delegate = self
            textfield.textAlignment = .center
            textfield.font = UIFont.systemFont(ofSize: 12)
            textfield.layer.borderColor = UIColor.gray.cgColor
            textfield.layer.borderWidth = 0.5
            textfield.layer.cornerRadius = 4
            textfield.clipsToBounds = true
            textFieldStack.addArrangedSubview(textfield)
        }
        if let textF = textFieldStack.subviews[0] as? UITextField {
            textF.becomeFirstResponder()
        }
        
    }
}


extension NewViewController: UITextFieldDelegate, OneTextNumberTextFieldDelegate {
    func enteredAllValue(string: String) {
        print(string)
    }
    
    func isAllValueEnterd(flag: Bool) {
        print(flag)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        let newLength = (textField.text ?? "").count + string.count - range.length
        
        if string == numberFiltered {
            
            
            if !string.isEmpty {
                textField.text = string
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
            } else {
                
                textField.text = ""
                for textFields in textFieldStack.subviews {
                    if textField == textFields {
                        if (textFields.tag - 1) > (-1) {
                            textFieldStack.subviews[textFields.tag - 1].becomeFirstResponder()
                            return false
                        }
                    }
                }
                textField.resignFirstResponder()
            }
        }
        return string == numberFiltered
    }
}



extension NewViewController: UITableViewDataSource, UITableViewDelegate {
    
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
    }
    
}
