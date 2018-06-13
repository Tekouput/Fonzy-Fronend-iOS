//
//  InfoMapShopViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/8/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class InfoMapShopViewController: UIViewController {

    var shopMapInfo: ShopMapInfo?
    
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
        
        if let shopInfo = shopMapInfo {
            shopName.text = shopInfo.name!
            shopPhoneNumber.text = shopInfo.internationalPhoneNumber!
            setUpShopSchedule(shopInfo: shopInfo)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUpShopSchedule(shopInfo: ShopMapInfo) {
        
        
        sundayOpenHour.text = String(describing: shopInfo.openingHours?.weekdayText?[0][(shopInfo.openingHours?.weekdayText?[0].index((shopInfo.openingHours?.weekdayText?[0].startIndex)!, offsetBy: 8))!])
        sundayCloseHour.text = ""
        mondayOpenHour.text = ""
        mondayCloseHour.text = ""
        tuesdayOpenHour.text = ""
        tuesdayCloseHour.text = ""
        wednesdayOpenHour.text = ""
        wednesdayCloseHour.text = ""
        thursdayOpenHour.text = ""
        thursdayCloseHour.text = ""
        fridayOpenHour.text = ""
        fridayCloseHour.text = ""
        saturdayOpenHour.text = ""
        saturdayCloseHour.text = ""
        
        /*
         "Monday: 9:30 AM – 9:00 PM",
         "Tuesday: 9:30 AM – 9:00 PM",
         "Wednesday: 9:30 AM – 9:00 PM",
         "Thursday: 9:30 AM – 9:00 PM",
         "Friday: 9:30 AM – 9:00 PM",
         "Saturday: 9:30 AM – 9:00 PM",
         "Sunday: 9:00 AM – 4:00 PM"
         
 
 */
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
