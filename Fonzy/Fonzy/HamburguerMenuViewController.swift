//
//  HamburguerMenuViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 1/29/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class HamburguerMenuViewController: UIViewController {

    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    var shop: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Ask for shop profile picture
        
        profilePicture.layer.cornerRadius = profilePicture.bounds.size.width * 0.5
        profilePicture.clipsToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        
        shopNameLabel.text = shop?.name
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
