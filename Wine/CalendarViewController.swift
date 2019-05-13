//
//  CalendarViewController.swift
//  Wine
//
//  Created by toxa on 4/30/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var prevMonthBtn: UIButton!
    @IBOutlet weak var calendView: CalendarView!
    @IBOutlet weak var wineBarView: WinesBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendView.delegate = self
        wineBarView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTopButtons()
    }
    
    @IBAction func prevMonthAction(_ sender: Any) {
        let date = calendView.currentDate
        let cal = Calendar.init(identifier: .gregorian)
        if let d = cal.date(byAdding: .month, value: -1, to: date) {
            calendView.currentDate = d.startOfMonth()
            calendView.changeMonth()
        }
        updateTopButtons()
    }
    
    @IBAction func nextMonthAction(_ sender: Any) {
        let date = calendView.currentDate
        let cal = Calendar.init(identifier: .gregorian)
        if let d = cal.date(byAdding: .month, value: 1, to: date) {
            if !d.monthMoreThen(date: Date()) {
                calendView.currentDate = d.startOfMonth()
                calendView.changeMonth()
            }
        }
        updateTopButtons()
    }
    
    func updateTopButtons(){
        let date = calendView.currentDate
        
        let year = Date().year() != date.year() ? " \(date.year())" : ""
        monthLabel.text = date.toString(format: "MMMM") + year
        
        let cal = Calendar.init(identifier: .gregorian)
        if let d = cal.date(byAdding: .month, value: -1, to: date) {
            let year = Date().year() != d.year() ? " \(d.year())" : ""
            prevMonthBtn.setTitle(d.toString(format: "MMMM") + year, for: .normal)
        }
        if let d = cal.date(byAdding: .month, value: 1, to: date) {
            let year = Date().year() != d.year() ? " \(d.year())" : ""
            nextMonthBtn.isEnabled = !d.monthMoreThen(date: Date())
            nextMonthBtn.setTitle(d.toString(format: "MMMM") + year, for: .normal)
        }
    }
    
    func showCancelView(itm: [WineRecordItem]){
        
        let cancelView = CancelView.loadFromNib()
        cancelView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        cancelView.items = itm
        cancelView.delegate = self
        self.tabBarController?.view.addSubview(cancelView)
        
        UIView.animate(withDuration: 0.3) {
            cancelView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }
        
    }
    
}

//MARK: WinesBarDelegate
extension CalendarViewController: WinesBarDelegate {
    
    func didDayTap(_ index: Int) {
        print("selected wine is \(index)")
        
        let date = calendView.selectedDay
        
        let wineObj = WineRecordItem(dateString: date.toString(format: RouterDB.dbDateFormat), date: date, wineType: WineType(rawValue: index)!)
        RouterDB.shared.addItem(item: wineObj)
        
        let y:CGFloat = wineBarView.frame.origin.y -  50
        showToast(message: "Add \( WineType(rawValue: index)?.name ?? "" )", duration: 3.0, y: y)
        calendView.changeMonth()
    }
    
}

//MARK: CalendarViewDelegate
extension CalendarViewController: CalendarViewDelegate {
    
    func didDayTap(_ date: Date) {
        print("selected date is \(date)")
        
        let itm = RouterDB.shared.getWineItems(date: date)
        
        if itm.count > 0 {
           showCancelView(itm: itm)
        }
        
    }
}

//MARK: CancelViewDelegate
extension CalendarViewController: CancelViewDelegate {
    func didDeleteItems(date: Date) {
        let items = RouterDB.shared.getWineItems(date: date)
        RouterDB.shared.deleteItems(itms: items)
        calendView.changeMonth()
    }
}
