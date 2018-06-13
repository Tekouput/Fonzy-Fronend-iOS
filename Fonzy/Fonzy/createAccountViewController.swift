//
//  createAccountViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 8/21/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class createAccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
 

    @IBOutlet var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.underlined()
        passwordTextField.underlined()        
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpViewController.dismissKeyboard)))
        
//        postUser()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTextField = textField.superview?.viewWithTag(textField.tag+1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){
        //
    }
    
    
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    
    }
    

    @IBAction func continueRegisterButton(_ sender: Any) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let passwordConfirmation = passwordTextField.text!
        
        postUser(email: email, password: password, passwordConfirmation: passwordConfirmation)
        
    }
    
    func postUser(email: String, password: String, passwordConfirmation: String){
        
        let parameters = ["email":"\(email)","password":"\(password)","password_confirmation":"\(passwordConfirmation)"]
        
        let urlString = Config.fonzyUrl + "users"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
        
        
        
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
