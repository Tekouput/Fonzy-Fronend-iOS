//
//  hairdresserTableViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class hairdresserTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    
//    override var isSelected: Bool {
//        didSet{
//            self.contentView.backgroundColor = isSelected ? UIColor(colorHexWithValue: 0x540226) : UIColor.white
//            self.name.textColor = isSelected ? UIColor.white : UIColor.black
//        }
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected { self.contentView.backgroundColor = UIColor(colorHexWithValue: 0x540226)
            self.name.textColor = UIColor.white
            
        }
        else{
            self.contentView.backgroundColor = UIColor.white
             self.name.textColor = UIColor.black
        }
        
    }

}
