//
//  DealsTableViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/7/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class DealsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dealName: UILabel!
    @IBOutlet weak var dealInitialDate: UILabel!
    @IBOutlet weak var dealEndDate: UILabel!
    @IBOutlet weak var savingAmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
