//
//  ViewController.swift
//  PageViewControllerDemo
//
//  Created by Rahul Vishwakarma  on 22/05/24.
//

import UIKit



class MenuCollectionCell: UICollectionViewCell {
    @IBOutlet weak var labelMenu: UILabel!
    
}

class PageViewMenuViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var collectionViewMenu: UICollectionView!
    
    let cellIdentifier = "MenuCollectionCell"
    var selectedIndex = 0
    
    var oldIndex = 0
    var controllers = [UIViewController]()
    var isFirstTimeViewDidAppear = true
    
    var pageViewController: UIPageViewController!
    
    var myMenuArray = ["Menu 1", "Menu 2", "Menu 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionViewSetuUp()
        addControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if isFirstTimeViewDidAppear {
            pageViewControllerSetUp()
            isFirstTimeViewDidAppear.toggle()
        }
    }
    
    
    
        
    
    func addControllers() {
        
        let controller1 = UIViewController()
        controller1.view.backgroundColor = .red
        let controller2 = UIViewController()
        controller2.view.backgroundColor = .green
        
        let controller3 = UIViewController()
        controller3.view.backgroundColor = .gray
        
        controllers.append(contentsOf: [controller1, controller2, controller3])
    }
        
        func pageViewControllerSetUp() {
            
            
            pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
            
            self.viewContainer.addSubview(pageViewController.view)
            pageViewController.view.frame = self.viewContainer.bounds
            
            addChild(pageViewController)
            didMove(toParent: pageViewController)
            
            pageViewController.delegate = self
            pageViewController.dataSource = self
            
            pageLoad(index: 0)
        }
        
        func pageLoad(index: Int) {
            
            guard index < controllers.count else { return }
            pageViewController.setViewControllers([controllers[index]], direction: selectedIndex < oldIndex ? .reverse : .forward, animated: true)  //this is for the scrolling direction and controller set
            
            oldIndex = selectedIndex
        }
        
        func collectionViewSetuUp() {
            nibRegister()
            collectionViewMenu.delegate = self
            collectionViewMenu.dataSource = self
        }
        
    func nibRegister() {
        collectionViewMenu.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }

    
}

extension PageViewMenuViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    
    //reverse method of pageview controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let indexOf = controllers.firstIndex(of: viewController) else { return nil }
            
            return indexOf > 0 ? controllers[indexOf - 1] : nil
            
            
        }
        
        //forward method of pageview controller
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            
            guard let indexOf = controllers.firstIndex(of: viewController) else { return nil }
            
            return indexOf < controllers.count - 1 ? controllers[indexOf + 1] : nil
        }
        
        
        
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            if let currentPage = pageViewController.viewControllers?.last {
                
                if let index = controllers.firstIndex(of: currentPage) {
                    
                    oldIndex = index
                    selectedIndex = index
                    
                    collectionViewMenu.reloadData()
                    
                }
                
            }
            
        }
    }
    
    
}

//Collection View
extension PageViewMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myMenuArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MenuCollectionCell else { return UICollectionViewCell() }
        
        
        cell.labelMenu.textColor = selectedIndex == indexPath.row ? UIColor.blue : .black
        cell.labelMenu.text = myMenuArray[indexPath.row]

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        pageLoad(index: selectedIndex)
        collectionViewMenu.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 20) / 3, height: collectionView.frame.height)
    }
    
    
    
}

