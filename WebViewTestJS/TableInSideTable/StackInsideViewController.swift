//
//  StackInsideViewController.swift
//  WebViewTestJS
//
//  Created by Rahul Vishwakarma on 03/01/25.
//

import UIKit


struct ChhotuModel {
    var isShowing: Bool
}

class StackInsideViewController: UIViewController {
    
    
    var showingIndex = -1
    
    
    var myArray = [ ChhotuModel(isShowing: false),
                    ChhotuModel(isShowing: false),
                    ChhotuModel(isShowing: false),
                    ChhotuModel(isShowing: false),
                    ChhotuModel(isShowing: false),
                    ChhotuModel(isShowing: false)
    ]
    
    
    @IBOutlet weak var tableViewContent: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableViewContent.register(UINib(nibName: "StackInsideTableViewCell", bundle: nil), forCellReuseIdentifier: "StackInsideTableViewCell")
        
        
        tableViewContent.delegate = self
        tableViewContent.dataSource = self
        
        
    }
    
}


extension StackInsideViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StackInsideTableViewCell") as? StackInsideTableViewCell
        
        
        cell?.viewConatainer.isHidden = myArray[indexPath.row].isShowing
        
        cell?.buttonHideShow.tag = indexPath.row
        cell?.buttonHideShow.addTarget(self, action: #selector(buttonHideShowTapped), for: .touchUpInside)
        return cell!
    }
    
    
    @objc func buttonHideShowTapped(_ sender: UIButton) {
        
        //showingIndex = sender.tag == showingIndex ? -1 : sender.tag
        
        myArray[sender.tag].isShowing.toggle()
        tableViewContent.reloadData()
    }
}
