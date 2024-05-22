//
//  AddAdvertiseView.swift
//  WebViewTestJS
//
//  Created by WYH IOS  on 16/05/24.
//

import UIKit

class AddAdvertiseView: NSObject {

    static let shared = AddAdvertiseView()

    
    var view: UIView?
    var collectionViewAdvertise: UICollectionView?
    
    var height = 150.0
        
    var data = ["34t", "34t", "34t", "34t"]
    
    
    override init() {
        super.init()
    }
    
    
    ///-------------------------------------------------------------------------
    func addSubView(parentView: UIView, height: CGFloat = 150.0) {
        self.height = height
        view = UIView()
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        
        collectionViewAdvertise = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: height), collectionViewLayout: layout)
       
        self.view?.addSubview(collectionViewAdvertise!)
        addLRTBHConstraints(parent: view!, child: collectionViewAdvertise!, height: height, isAddTop: true)
        
        let bundle = Bundle(for: AddAdvertiseCollectionViewCell.self)
        
        
        let nib = UINib(nibName: "AddAdvertiseCollectionViewCell", bundle: bundle)
        
        collectionViewAdvertise?.register(nib, forCellWithReuseIdentifier: "AddAdvertiseCollectionViewCell")
        
        collectionViewAdvertise?.isPagingEnabled = true
        collectionViewAdvertise?.backgroundColor = .brown
        
        collectionViewAdvertise?.dataSource = self
        collectionViewAdvertise?.delegate = self
        
        parentView.addSubview(self.view!)
        addLRTBHConstraints(parent: parentView, child: self.view!, bottom: 50)
        
    }
    ///-------------------------------------------------------------------------
    public func addLRTBHConstraints(parent: UIView, child: UIView, height: CGFloat = 150, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0, isAddTop: Bool = false) {
        
        child.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint(item: child, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: leading).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: trailing).isActive = true
        
        if isAddTop {
            NSLayoutConstraint(item: child, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: top).isActive = true
        }
        NSLayoutConstraint(item: child, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -bottom).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height).isActive = true
        
    }
    ///-------------------------------------------------------------------------
}

extension AddAdvertiseView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    ///-------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAdvertiseCollectionViewCell", for: indexPath) as? AddAdvertiseCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    ///-------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 10
        let height = self.height
        
        return CGSize(width: width, height: self.height)
    }
    
}
