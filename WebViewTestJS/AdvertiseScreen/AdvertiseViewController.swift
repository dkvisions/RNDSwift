//
//  AdvertiseViewController.swift
//  WebViewTestJS
//
//  Created by WYH IOS  on 10/05/24.
//

import UIKit

class AdvertiseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIViewController {
    
    func addLRBHConstraintsN(parent: UIView, child: UIView, _ height: CGFloat = 150,_ leading: CGFloat = 0,_ trailing: CGFloat = 0,_ bottom: CGFloat = 0) {
        
        child.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint(item: child, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: leading).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: trailing).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: bottom).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height).isActive = true
        
    }

    func addAdvertVCN() {
        let advertVC = AdvertiseViewController()
        self.view.addSubview(advertVC.view)
        self.addLRBHConstraints(parent: self.view, child: advertVC.view)
        addChild(advertVC)
        didMove(toParent: advertVC)
    }
}
