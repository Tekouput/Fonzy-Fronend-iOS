//
//  editShopInfoViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 1/27/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class editShopInfoViewController: UIViewController {

    
    @IBOutlet weak var addressTextField: JVFloatLabeledTextField!
    @IBOutlet weak var phoneTextField: JVFloatLabeledTextField!
    @IBOutlet weak var bioTextField: JVFloatLabeledTextField!
    @IBOutlet weak var updateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func UpdateButton(_ sender: Any) {
        
        //UPDATE shop info on API
        
        
        
        self.dismiss(animated: true, completion: nil)
        
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
