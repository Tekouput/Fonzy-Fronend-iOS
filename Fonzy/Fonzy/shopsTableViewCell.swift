//
//  shopsTableViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import Cosmos

class shopsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopStreetName: UILabel!
    @IBOutlet weak var shopDistance: UILabel!
    @IBOutlet weak var shopRating: CosmosView!
    @IBOutlet weak var shopProfileImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
