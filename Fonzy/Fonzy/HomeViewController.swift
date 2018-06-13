//
//  HomeViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 9/15/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreLocation

class HomeViewController: ButtonBarPagerTabStripViewController {

    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        

        // Do any additional setup after loading the view.
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0 
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let searchOptionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchOptionsViewController")
        
        let dealsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dealsViewController")
        
        let notificationsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notificationsViewController")
        
        return [searchOptionsViewController, dealsViewController, notificationsViewController]
        
    }
    
    
    //FUNCTION TO HANDLE USER CHANGES ON LOCATION PRIVACY
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            //disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse:
            //enableMyWhenInUseFeatures()
            break
            
        case .notDetermined, .authorizedAlways:
            break
        }
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
