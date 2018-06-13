//
//  bookmarkTableViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import Cosmos

class bookmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var shopIcon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
