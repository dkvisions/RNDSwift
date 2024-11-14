//
//  Chat360ViewController.swift
//  WebViewTestJS
//
//  Created by Rahul Vishwakarma on 31/10/24.
//

import UIKit
import SwiftUI

class Chat360ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var appId = ""
    var botId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHostingView()
    }
    
    
    func setUpHostingView() {
        
//        let chatConfig = Chat360Config(botId: botId, appId: appId)
//        let chatView = Chat360BotView(botConfig: chatConfig)
//    
//        let viewController = UIHostingController(rootView: chatView)
//        
//        self.view.addSubview(view)
//        addLRBHConstraints(parent: containerView, child: viewController.view)
        
    }
}


public func addLRBHConstraints(parent: UIView, child: UIView, _ leading: CGFloat = 0,_ trailing: CGFloat = 0, _ top: CGFloat = 0, bottom: CGFloat = 0) {
    
    child.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: child, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: leading).isActive = true
    
    NSLayoutConstraint(item: child, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: trailing).isActive = true
    
    NSLayoutConstraint(item: child, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: top).isActive = true
    
    NSLayoutConstraint(item: child, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: bottom).isActive = true
    
    
}
