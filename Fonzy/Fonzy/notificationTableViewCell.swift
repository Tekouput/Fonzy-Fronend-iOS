//
//  notificationTableViewCell.swift
//  Fonzy
//
//  Created by fitmap on 11/16/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class notificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var descrip: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
