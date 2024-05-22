//
//  AdvertisingView.swift
//  WebViewTestJS
//
//  Created by WYH IOS  on 13/05/24.
//

import UIKit

public class AdvertisingView: UIView {

    public class func instanceFromNib() -> UIView {
        return UINib(nibName: "AdvertisingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}




extension UIViewController {
    
    public func addLRBHConstraints(parent: UIView, child: UIView, _ height: CGFloat = 150,_ leading: CGFloat = 0,_ trailing: CGFloat = 0,_ bottom: CGFloat = 0) {
        
        child.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint(item: child, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: leading).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: trailing).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: bottom).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height).isActive = true
        
    }
    
    
    
    public func addAdvertVC() {
        let view_ = AdvertisingView.instanceFromNib()
        self.view.addSubview(view_)
        self.addLRBHConstraints(parent: self.view, child: view_)
    }
}



