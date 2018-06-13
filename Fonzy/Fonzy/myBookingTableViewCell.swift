//
//  myBookingTableViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class myBookingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var service: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var barberShop: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
