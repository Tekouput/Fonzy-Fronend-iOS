//
//  shopInfoViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/10/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class shopInfoViewController: UIViewController {

    var shopInfo: Store?
    var shopOwnerInfo: Authenticate?
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopPhoneNumber: UILabel!
    @IBOutlet weak var shopOwner: UILabel!
    @IBOutlet weak var shopOwnerPhoneNumber: UILabel!
    @IBOutlet weak var shopDescription: UITextView!
    
    @IBOutlet weak var sundayOpenHour: UILabel!
    @IBOutlet weak var sundayCloseHour: UILabel!
    @IBOutlet weak var mondayOpenHour: UILabel!
    @IBOutlet weak var mondayCloseHour: UILabel!
    @IBOutlet weak var tuesdayOpenHour: UILabel!
    @IBOutlet weak var tuesdayCloseHour: UILabel!
    @IBOutlet weak var wednesdayOpenHour: UILabel!
    @IBOutlet weak var wednesdayCloseHour: UILabel!
    @IBOutlet weak var thursdayOpenHour: UILabel!
    @IBOutlet weak var thursdayCloseHour: UILabel!
    @IBOutlet weak var fridayOpenHour: UILabel!
    @IBOutlet weak var fridayCloseHour: UILabel!
    @IBOutlet weak var saturdayOpenHour: UILabel!
    @IBOutlet weak var saturdayCloseHour: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let shopInfo = shopInfo {
            
            let firstName = shopOwnerInfo?.user.firstName ?? ""
            let lastName = shopOwnerInfo?.user.lastName ?? ""
            
            shopName.text = shopInfo.name
            shopPhoneNumber.text = shopOwnerInfo?.user.phoneNumber ?? "No number"
            shopOwner.text = "\(firstName) \(lastName)"
            shopOwnerPhoneNumber.text = shopOwnerInfo?.user.phoneNumber ?? "No number"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
