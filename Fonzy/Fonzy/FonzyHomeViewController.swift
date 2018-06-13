//
//  FonzyHomeViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/10/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Pulley

struct Search {
    static var type = Style.barberShop
}

class FonzyHomeViewController: UIViewController {

    
    var user: Authenticate?

    @IBOutlet weak var notificationContainerHeightConstraint: NSLayoutConstraint!
    var notificationCenter = NotificationCenterState.up
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //375 // height: 360

        let authKey = KeychainWrapper.standard.string(forKey: "authToken")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainCustomerVC(segue: UIStoryboardSegue){
    }
    
    
    @IBAction func BarberShopsButtonPressed(_ sender: Any) {
        Search.type = .barberShop
    }
    @IBAction func BeautySalonButtonPressed(_ sender: Any) {
        Search.type = .beautySalon
    }
    @IBAction func HairdressersButtonPressed(_ sender: Any) {
        Search.type = .independent
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        
//        //
//        if let destination = segue.destination as? PulleyViewController {
//            destination.setDrawerPosition(position: .partiallyRevealed)
//
//        }
//
        
        if let destination = segue.destination as? MenuViewController {
            destination.user = user?.user
        }
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        
        if notificationCenter == .up {
            // Pull down constraint
            
            notificationContainerHeightConstraint.constant = 250
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            notificationCenter = .down
        } else {
            // Is down, pull up
            notificationContainerHeightConstraint.constant = 105
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            notificationCenter = .up
        }
        
    }
    
    

}
