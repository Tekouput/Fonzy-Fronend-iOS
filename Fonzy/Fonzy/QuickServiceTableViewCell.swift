//
//  QuickServiceTableViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 1/29/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class QuickServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }

}
