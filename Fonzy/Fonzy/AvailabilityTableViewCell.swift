//
//  AvailabilityTableViewCell.swift
//  Fonzy
//
//  Created by fitmap on 2/2/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class AvailabilityTableViewCell: UITableViewCell, pickerChangedDelegate {

    
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startTimeTextField: PickerTextField!
    @IBOutlet weak var endTimeTextField: PickerTextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            checkboxImage.image = UIImage(named: "boxChecked")
            dayLabel.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9176470588, blue: 0.8274509804, alpha: 1) //UIColor(red: 243, green: 234, blue: 211, alpha: 0)
        }
       
    }
    func onPickerChanged(val date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        startTimeTextField.text = dateFormatter.string(from: date)
    }

    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        //        birthdayTextField.text = dateFormatter.string(from: sender.date)

        startTimeTextField.text = dateFormatter.string(from: sender.date)
        //        birthdayTextField.text = dateFormatter.string(from: sender.date)
        
    }

}



class PickerTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
