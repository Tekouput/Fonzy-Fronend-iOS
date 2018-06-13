//
//  DealsViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 9/15/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DealsViewController: ViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {

    @IBOutlet var dealsTableView: UITableView!
    let cellIdentifier = "dealCell"
    var deals = [Deal]()
    
    override func viewDidLoad() {
//        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dealsTableView.delegate = self
        dealsTableView.dataSource = self
        dummyDeals()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Deals")
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deals.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DealsTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        let deal = deals[indexPath.row]
        
        cell.dealName.text = deal.name
        cell.dealInitialDate.text = "\(deal.initialDate)"
        cell.dealEndDate.text = "\(deal.endDate)"
        cell.savingAmount.text = "\(deal.saving)%"
        
        return cell
    }
    
    
    
    //Go to booking
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func dummyDeals() {
        
        
        let deal = Deal(id: 01, name: "Come and get it", description: "Ok", initialDate: Date(), endDate: Date(), saving: 34.5)
        
        let deal2 = Deal(id: 02, name: "Black Friday", description: "Ok", initialDate: Date(), endDate: Date(), saving: 34.5)
        
        deals = [deal, deal2]
        
    }
    
    
    @IBAction func unwindToDeals(segue: UIStoryboardSegue){
        //
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
