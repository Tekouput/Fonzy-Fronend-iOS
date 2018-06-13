//
//  editShopProfileViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class editShopProfileViewController: UIViewController{
    
    @IBOutlet weak var doneEdittingButton: UIButton!
    
    var shop: Store?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        doneEdittingButton.layer.cornerRadius = doneEdittingButton.bounds.size.width * 0.5
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? UINavigationController {
            if let editServicesVC = destination.viewControllers.first as? editServicesViewController {
                editServicesVC.shop = shop
            }
        }
        
        if let destination = segue.destination as? editShopTeamTableViewController {
            destination.shop = shop
        }
        
    }
    
    @IBAction func unwindToEditShopProfile(segue: UIStoryboardSegue){
        
        
    }

    

}
