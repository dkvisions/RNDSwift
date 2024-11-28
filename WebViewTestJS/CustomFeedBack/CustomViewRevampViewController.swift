//
//  CustomViewRevampViewController.swift
//  WebViewTestJS
//
//  Created by Rahul Vishwakarma on 21/10/24.
//

import UIKit

class CustomViewRevampViewController: UIViewController {

    let customRespo = getReponseCustomFeedBack()
    
    
    
    let shared = CoreDataHelper.shared
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        
//        for i in customRespo?.customFeedback ?? [] {
//            
//            
//            print("i in \(i.type ?? "-")")
//        }
//        
//        
//        shared.saveData()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        shared.fetchData()
    }
    @IBAction func navigateButton(_ sender: Any) {
        
        let vc = QuestionsOptionsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
