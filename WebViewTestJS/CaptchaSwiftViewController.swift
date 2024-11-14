//
//  CaptchaSwiftViewController.swift
//  WebViewTestJS
//
//  Created by WYH IOS  on 06/06/24.
//

import UIKit
import Foundation

class CaptchaSwiftViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    var labels = [UILabel]()

  
    let captchaValue = ["Z", "g", "T", "v", "0", "q", "r", "j", "B", "W", "L", "x", "a", "o", "Y", "9", "7", "d", "M", "O", "C", "F", "P", "R", "H", "2", "m", "A", "3", "G", "N", "1", "E", "I", "b", "4", "n", "U", "S", "c", "5", "e", "l", "Q", "J", "V", "w", "h", "u", "s", "8", "p", "X", "t", "f", "D", "6", "z", "k", "K", "y"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        reloadCaptcha()
    }
    
    private func captchaInitialSetup() {
        labels = [label1, label2, label3, label4, label5, label6]
        for i in 0...labels.count-1 {
        
          let value =  i % 2 == 0 ? -20.0 : 20.0
            let font = i % 2 == 0 ? UIFont.systemFont(ofSize: 12, weight: .bold) : UIFont.systemFont(ofSize: 18, weight: .regular)
            labels[i].font = font
            labels[i].rotate(angle: value)
        }
       
        reloadCaptcha()
      
    }
    
    
    
    
    fileprivate func reloadCaptcha() {
        var random6Array = [String]()

        for _ in 0...5 {
            random6Array.append("\(captchaValue.randomElement() ?? "")")
        }
        
        for i in 0...5 {
            labels[i].text = random6Array[i]
            
        }
    
    }
}




extension UIView {
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = CGAffineTransformRotate(self.transform, radians);
        self.transform = rotation
    }
}


extension Array {
    mutating func customShuffle() {
        for i in stride(from: self.count - 1, through: 1, by: -1) {
            let j = Int(arc4random_uniform(UInt32(i + 1)))
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}

