//
//  calendarViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/19/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import JTAppleCalendar

struct BookingSelected {
    static var date: Date?
}

class calendarViewController: UIViewController {
    
    let monthColor = UIColor(colorHexWithValue: 0x540226)
    let selectedDateTextColor = UIColor(colorHexWithValue: 0xF7BD59)
    
    let formatter = DateFormatter()

    
//    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    

 
        setUpCalendarView()
    }

    func setUpCalendarView(){
        
        //Set up calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView Methods


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        
        guard let validcell = view as? calendarCollectionViewCell else {
            return
        }
        
        if cellState.isSelected{
            validcell.selectedView.isHidden = false
        }else{
            validcell.selectedView.isHidden = true
        }
        
    }
    
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        
        guard let validcell = view as? calendarCollectionViewCell else {
            return
        }
        
        if cellState.isSelected{
            validcell.dateLabel.textColor = selectedDateTextColor
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                validcell.dateLabel.textColor = UIColor.black
            }else{
                validcell.dateLabel.textColor = UIColor.gray
            }
        }
        
    }
    
    
}



extension calendarViewController: JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        // Get the current date
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let startDate = formatter.date(from: "\(year!) \(month!) \(day!)")
        let endDate = formatter.date(from: "2050 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        
        return parameters
    }
    
    

}



extension calendarViewController: JTAppleCalendarViewDelegate {
    
    // Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt
        date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! calendarCollectionViewCell
        
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        cell.dateLabel.text = cellState.text
        
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        BookingSelected.date = date
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {

        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {

        setupViewsOfCalendar(from: visibleDates)
    
    }
    
    
}




extension UIColor {
    
    convenience init(colorHexWithValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8 ) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
}










