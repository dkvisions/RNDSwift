//
//  QuestionsOptionsTableCell.swift
//  AudioVideo
//
//  Created by Rahul Vishwakarma  on 27/03/24.
//

import UIKit

class QuestionsOptionsTableCell: UITableViewCell {

    var optionsData: String! {
        didSet {
            configureCell()
        }
    }
    
    
    @IBOutlet weak var labelOptions: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 8
        
    }
    
    private func configureCell() {
        labelOptions.text = optionsData
    }

    
    
    
}
