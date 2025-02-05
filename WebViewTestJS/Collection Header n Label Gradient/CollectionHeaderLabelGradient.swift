//
//  CollectionHeaderLabelGradient.swift
//  WebViewTestJS
//
//  Created by Rahul Vishwakarma on 27/12/24.
//

import UIKit

class CollectionHeaderLabelGradient: UIViewController {

    @IBOutlet weak var labelVoucher: UILabel!
    @IBOutlet weak var collectionForeader: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configure()
    }

    
    
    func configure() {
        
        let color1 = UIColor.hexStringToUIColor(hex: "#107E94").cgColor
        let color2 = UIColor.hexStringToUIColor(hex: "#13BCDC").cgColor
        let color3 = UIColor.hexStringToUIColor(hex: "#03687B").cgColor
        let color4 = UIColor.hexStringToUIColor(hex: "#1A8194").cgColor
        let color5 = UIColor.hexStringToUIColor(hex: "#42B3C8").cgColor
        
        
        let gradientImage = UIImage.gradientImageWithBounds(bounds: labelVoucher.bounds, colors: [color1, color2, color3, color4, color5])
        
        labelVoucher.textColor = UIColor(patternImage: gradientImage)
    }
}


extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIColor {
    public static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }}
