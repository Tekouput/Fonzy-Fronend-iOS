//
//  manualBookingViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class manualBookingViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstName: JVFloatLabeledTextField!
    
    @IBOutlet weak var lastName: JVFloatLabeledTextField!
    
    @IBOutlet weak var email: JVFloatLabeledTextField!
    
    @IBOutlet weak var notes: UITextView!
    
    @IBOutlet weak var phoneNumber: JVFloatLabeledTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manualBookingViewController.dismissKeyboard)))
        
        
    }

    
    
    @IBAction func pickTimeTouched(_ sender: Any) {
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func dismissKeyboard() {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        email.resignFirstResponder()
        notes.resignFirstResponder()
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...2:
            print("ok")
        default:
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
