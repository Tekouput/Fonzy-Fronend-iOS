//
//  userProfileViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 9/19/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class userProfileViewController: UIViewController {
    
    var user: UserAuth?
    
    let navBarColor = UIColor(colorHexWithValue: 0x645023)
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLastName: UILabel!
    @IBOutlet weak var userSex: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userZipCode: UILabel!
    
    var usrSex = Sex.female
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = navBarColor
        
    navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.white
        
        setupUserProfile()
        
    }

    func setupUserProfile() {

        
        if let user = user {
            
            let firstName = user.firstName ?? ""
            let lastName = user.lastName ?? ""
            
            userName.text = firstName
            userLastName.text = lastName
//            let userSex =
            if user.sex == "Female" { usrSex = .female }
            if user.sex == "Male" { usrSex = .male }
            
            if usrSex == .male{
                userSex.text = "Male"
            }else{
                userSex.text = "Female"
            }
            
            if let birthdate = user.birthday {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
//                userAge.text = dateFormatter.string(from: birthdate)
                userAge.text = birthdate
            }
            /*
            dateFormatter.dateStyle = DateFormatter.Style.short
            pickedDate = dateFormatter.string(from: sender.date)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
            let hour = (components.hour! * 60) * 60
            let minute = (components.minute! * 60 )
            pickedTime = "\(hour + minute)"

            
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.day, .month, .year], from: today!, to: birthday!)
            let formatter = DateFormatter.Style.short
            
            userAge.text = "\(components)"
            */
            if let phoneNumber = user.phoneNumber {
                userPhoneNumber.text = phoneNumber
            }
            if let zipCode = user.address?.zipCode {
                userZipCode.text = zipCode
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToUserProfile(segue: UIStoryboardSegue){
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if let editProfileVC = segue.destination as? editUserProfileViewController {
            editProfileVC.user = user
            editProfileVC.usrSex = usrSex
        }
        
        
    }
    

}
