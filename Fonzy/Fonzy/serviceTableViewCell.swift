//
//  serviceTableViewCell.swift
//  Fonzy
//
//  Created by fitmap on 11/16/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class serviceTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    @IBOutlet weak var addServiceButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addServiceButton.clipsToBounds = true
        addServiceButton.layer.cornerRadius = addServiceButton.bounds.size.width * 0.5
        
//        addServiceButton.addTarget(self, action: #selector(servicesTableViewController.goToSetBooking(sender:self)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
        
    }

}
