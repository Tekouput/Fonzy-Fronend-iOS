//
//  RolePickerViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/6/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class RolePickerViewController: UIViewController {


    var userRole = Role.customer
    @IBOutlet var isCustomerButton: UIButton!
    @IBOutlet var isShopOwnerButton: UIButton!
    @IBOutlet var isHairdresserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var isCustomer = true
    var isHairdresser = false
    var isShopOwner = false
    
    @IBAction func isCustomer(_ sender: Any) {
        
        if isCustomer {
            isCustomerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isCustomer = false
        }else{
            isCustomerButton.setImage(UIImage(named: "boxCheckedWhite"), for: .normal)
            
            isShopOwnerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isHairdresserButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isCustomer = true
            isShopOwner = false
            isHairdresser = false
            userRole = .customer
        }
    }
    
    
    @IBAction func isShopOwner(_ sender: Any) {
        
        if isShopOwner {
            isShopOwnerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isShopOwner = false
        }else{
            isShopOwnerButton.setImage(UIImage(named: "boxCheckedWhite"), for: .normal)
            isHairdresserButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isCustomerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isShopOwner = true
            isCustomer = false
            isHairdresser = false
            userRole = .shopOwner
        }
    }
    
    
    @IBAction func isHairdresser(_ sender: Any) {
        
        if isHairdresser {
            isHairdresserButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            
            isHairdresser = false
        }else{
            isHairdresserButton.setImage(UIImage(named: "boxCheckedWhite"), for: .normal)
            
            //            isHairdresserButton.imageView?.image = UIImage(named: "boxCheckedWhite")
            isShopOwnerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isCustomerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isHairdresser = true
            isShopOwner = false
            isCustomer = false
            userRole = .hairdresser
        }
    }

    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if userRole == .customer {
           
           let fonzyHomeVC = storyboard.instantiateViewController(withIdentifier: "fonzyHomeViewController")
            
            self.present(fonzyHomeVC, animated: true, completion: nil)
            
        } else if userRole == .hairdresser || userRole == .shopOwner {
            let shopPickerVC = storyboard.instantiateViewController(withIdentifier: "shopPickerViewController") as! shopPickerViewController
            shopPickerVC.userRole = userRole
            
             self.present(shopPickerVC, animated: true, completion: nil)
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
