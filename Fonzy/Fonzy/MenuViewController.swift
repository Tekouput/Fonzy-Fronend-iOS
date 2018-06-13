//
//  MenuViewController.swift
//  Fonzy
//
//  Created by fitmap on 2/5/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Stripe
import MessageUI


class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var shop = Shop(withId: "\(01)", name: "Shop", status: "Active", longitude: 0.0, latitude: 0.0, zipCode: "0", description: "Best shop", rating: 5, pictures: [UIImage(named: "6")!])
    
    var user: UserAuth?
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var customerName: UILabel!
   
    @IBOutlet weak var logOutButton: UIButton!
    
    var ok = "Ok"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        profilePicture.layer.cornerRadius = profilePicture.bounds.size.width * 0.5
        profilePicture.clipsToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        
        if let usr = user {
            let firstName = usr.firstName ?? ""
            let lastName = usr.lastName ?? ""
            customerName.text = "\(firstName) \(lastName)"
            
            print("User has image? : ", usr.profilePicture?.id)
        }
        
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
    
    
    @IBAction func LogOutBtnTapped(_ sender: Any) {
        _ = KeychainWrapper.standard.removeObject(forKey: "authToken")
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? userProfileViewController {
            destination.user = user
        }
    }
    
    @IBAction func payoutMethodButtonTapped(_ sender: Any) {
//        choosePaymentButtonTapped()
    }
    //
    //    func choosePaymentButtonTapped() {
    //        self.paymentContext.pushPaymentMethodsViewController()
    //    }
    //
    
    // MARK: - Mail methods
    
    @IBAction func SupportButton(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["fonzyinc@icloud.com"])
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    

}
