//
//  StackInsideTableViewCell.swift
//  WebViewTestJS
//
//  Created by Rahul Vishwakarma on 03/01/25.
//

import UIKit

class StackInsideTableViewCell: UITableViewCell {

    @IBOutlet weak var viewConatainer: UIView!
    @IBOutlet weak var buttonHideShow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
