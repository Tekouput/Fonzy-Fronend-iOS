//
//  RatingViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/10/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController {

    var shopRating: Double?
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let rating = shopRating {
            ratingView.rating = rating
            ratingLabel.text = "\(rating)"
        } else {
            ratingLabel.text = "Not enough ratings"
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
