//
//  ViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 8/6/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import SwiftKeychainWrapper


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var signInButton: UIButton!

    @IBOutlet weak var facebookLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        facebookLoginButton.title
        
        backgroundImageView.animationImages = [UIImage(named:"2")!,  UIImage(named:"4")!,UIImage(named:"5")!,UIImage(named:"6")! ]
        backgroundImageView.animationDuration = 8
        backgroundImageView.startAnimating()
        
        
        
        //        //Facebook login button
        //        let logginButton = FBSDKLoginButton()
        //
        //        logginButton.frame = CGRect(x: 20, y: 593, width: 152, height: 37)
        //        view.addSubview(logginButton)
        //
        //        logginButton.readPermissions = ["email", "public_profile"]
        //        logginButton.delegate = self
        //
        //
        
        //        if let label = createAccountButton.titleLabel {
        //            label.minimumScaleFactor = 0.5
        //            label.adjustsFontSizeToFitWidth = true
        //        }
        
        // Check if user is LogIn
        if let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken") {
            // Check user profile
            print("Yes I am log in: ", userAuthKey)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let customerNVC = storyboard.instantiateViewController(withIdentifier: "fonzyHomeViewController") as? UINavigationController {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController!.present(customerNVC, animated: true, completion: nil)
            }
        }
        
    }
    

    /*********************************************************
     *                 Facebook login methods                *
     ********************************************************/
    // Once the button is clicked, show the login dialog
    
    
    @IBAction func facebookButtonClicked(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { [weak self] (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result)
                    // Display an loading animation
                    
                    self?.logUser()

                }
            })
        }
    }
    
    func logUser() {
        
        //Once I have the FB token key, I'll send a request to our API, once I get the token, I'll sign in
        let link = Config.fonzyUrl + "user/facebook/token"
        
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print(FBSDKAccessToken.current())
        print("DIFERENT")
        print("\(FBSDKAccessToken.current().tokenString)")
        request.addValue(FBSDKAccessToken.current().tokenString, forHTTPHeaderField: "Authorization")
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, err) in
            
            do{
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    if let userAuthKey = json["auth_token"] as? String{
                        _ = KeychainWrapper.standard.set(userAuthKey, forKey: "authToken")
                        
                        
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        
                        // parse new object
                        let user = try JSONDecoder().decode(Authenticate.self, from: data)
                        print(json)
                        DispatchQueue.main.async {
                            if user.newUser {
                                
                                self.present(storyboard.instantiateViewController(withIdentifier: "rolePickerViewController"), animated: true, completion: nil)
                            } else {
                                self.present(storyboard.instantiateViewController(withIdentifier: "fonzyHomeViewController"), animated: true, completion: nil)
                            }
                            
                        }
                       
                        // Open new window
//                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//                        self.present(storyboard.instantiateViewController(withIdentifier: "fonzyHomeViewController"), animated: true, completion: nil)
//                        "rolePickerViewController"
                        
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            
            }.resume()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("I log out from Facebook")
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil{
            print(error)
            return
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, last_name, email, age_range, gender"]).start { (connection, result, error) in
            
            if error != nil {
                print("Failed Graph Request", error)
                return
            }
            
            print(result)
            print("!!!!!!!!!!!!!!!! ACCESS TOKEN !!!!!!!!!!!!!!!!")
            print(FBSDKAccessToken.current())
        }
        
        
        
        
        
    }
    
    
    
    @IBAction func unwindToInitialViewController(segue: UIStoryboardSegue){
        
    }
    
    /*********************************************************
     *               END of Facebook login methods           *
     ********************************************************/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

