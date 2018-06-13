//
//  ShopPickerTableViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/9/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class ShopPickerTableViewCell: UITableViewCell {

    @IBOutlet weak var shopProfilePicture: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
