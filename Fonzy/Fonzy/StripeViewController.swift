//
//  StripeViewController.swift
//  Fonzy
//
//  Created by fitmap on 3/21/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import Stripe
import JVFloatLabeledTextField
import SwiftKeychainWrapper

class StripeViewController: UIViewController {
   
    
    var showCancelButton = false
    
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var creditCardTextField: JVFloatLabeledTextField!
    @IBOutlet weak var expirationMonthTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var expirationYearTextFIeld: JVFloatLabeledTextField!
    @IBOutlet weak var securityCodeTextField: JVFloatLabeledTextField!
    @IBOutlet weak var amountToPayTextField: JVFloatLabeledTextField!
    
    // Custom activity indicator properties
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCardButton.layer.cornerRadius = 15
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StripeViewController.dismissKeyboard)))
        
        if(showCancelButton) {
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Stripe methods
    
    @IBAction func AddCardButtonTapped(_ sender: Any) {
        
        activityIndicator("Adding Card")
        // Initiate the card
        let cardParams = STPCardParams()
        guard let cardNumber = creditCardTextField.text else {return}
        guard let expMonth = expirationMonthTextField.text else {return}
        guard let expYear = expirationYearTextFIeld.text else {return}
        guard let cvc = securityCodeTextField.text else {return}
        
        guard let UIntExpMonth = UInt(expMonth) else {return}
        guard let UIntExpYear = UInt(expYear) else {return}

        
        cardParams.number = cardNumber
        cardParams.expMonth = UIntExpMonth
        cardParams.expYear = UIntExpYear
        cardParams.cvc = cvc
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            
            guard let token = token, error == nil else {
                // Present error to user...
                print("HEEY ERROR")
                print(error)
                
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    let alert = UIAlertController(title: "Couldn't insert card", message: "An error occured while inserting your card. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                
                return
            }
            
            let invoiceId = 01
            guard let userToken = KeychainWrapper.standard.string(forKey: "authToken") else {return}
            
            /*
            PaymentMethods.payInvoice(withId: invoiceId, cardToken: token, authorization: userToken, completion: {
                
                print("HEEY PAYMENT DONEEE")

            })
             */
            
            print("HEEY TOKEN RECIEVED SUCCESSFULLY")
            print("Token ID: ", token.tokenId)
            print(token)
            
            DispatchQueue.main.async {
                self.stopActivityIndicator()
            }
            
        }
        
    }
    
    @objc func dismissKeyboard() {
        creditCardTextField.resignFirstResponder()
        expirationMonthTextField.resignFirstResponder()
        expirationYearTextFIeld.resignFirstResponder()
        securityCodeTextField.resignFirstResponder()
    }
    
    @IBAction func CancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        effectView.removeFromSuperview()
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
