//
//  HairdresserSearchTableViewCell.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/10/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class HairdresserSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
