//
//  NotificationCenterViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 5/22/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

enum NotificationCenterState {
    case up
    case down
}

class NotificationCenterViewController: UIViewController {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullButton: UIButton!
    
    var notificationCenter = NotificationCenterState.up
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PullNotificationCenter(_ sender: Any) {
        
        if notificationCenter == .up {
            // Pull down constraint
            
            heightConstraint.constant = 250
            self.preferredContentSize = CGSize(width: self.preferredContentSize.width, height: 250)
            
            let downImage = UIImage(named: "downWhite")!
            pullButton.setImage(downImage, for: .normal)
            self.view.layoutIfNeeded()
            
            notificationCenter = .down
        } else {
            // Is down, pull up
            heightConstraint.constant = 105
            self.preferredContentSize = CGSize(width: self.preferredContentSize.width, height: 105)

            self.view.layoutIfNeeded()
            
            let downImage = UIImage(named: "backWhite")!
            pullButton.setImage(downImage, for: .normal)
            
            notificationCenter = .up
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
