//
//  hairdresserCollectionViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/18/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class hairdresserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override var isSelected: Bool {
        didSet{
            self.contentView.backgroundColor = isSelected ? UIColor(colorHexWithValue: 0x540226) : UIColor.lightGray
            self.name.textColor = isSelected ? UIColor.white : UIColor.black
        }
    }
    
}
