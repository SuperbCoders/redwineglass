//
//  StatisticsViewController.swift
//  Wine
//
//  Created by toxa on 4/30/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var theCostLabel: UILabel!
    @IBOutlet weak var drunkTotalLabel: UILabel!
    @IBOutlet weak var drunkLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var statsView: StatisticView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var countlabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var prevMonthBtn: UIButton!
    private var selectedPeriodDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Statistics".localized()
        drunkLabel.text = "Drunk on averange".localized()
        drunkTotalLabel.text = "Drunk total".localized()
        theCostLabel.text = "The cost of drinking wine".localized()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction(_:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateInfo()
        updateTopButtons()
        
        setupView()
    }
    
    private func setupView(){
        if (DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR || DeviceType.IS_IPHONE_XSMAX) {
            
        }else{
            bottomHeight.constant = 90.0
            if DeviceType.IS_IPHONE_6 {
                bottomHeight.constant = 45.0
            }
        }
    }
    
    private func calculateInfo(){
        
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        let monthText = df.string(from: selectedPeriodDate)
        
        let endMonth = selectedPeriodDate.endOfMonth()
        let last = endMonth// > Date() ? Date() : endMonth
        
        df.dateFormat = "d"
        
//        let text = "1st of " + monthText + " — " + df.string(from: last) + "st of " + monthText
//        periodButton.setTitle(text, for: .normal)
        
        let items = RouterDB.shared.getWineItems(startDate: selectedPeriodDate.startOfMonth(), endDate: last)
        let text = glassesLocalizeCount(c: items.count) //items.count == 1 ? "glass".localized() : "glasses".localized();
        
        countlabel.text = "\(items.count) " + text
        averageLabel.text = String(format: "%d %@", Int(ceil(Float(items.count) / Float(df.string(from: last))!)), "glasses daily".localized())
        
        var s:Float = 0
        items.forEach { (w) in
            s += w.wineType.cost
        }
        costLabel.text = "~ $\(s)"
        
        statsView.items = items
    }

    private func glassesLocalizeCount(c:Int)->String{
        if let locale = NSLocale.current.languageCode {
            if !locale.lowercased().contains("ru") {
                return c > 1 ? "glasses".localized() : "glass".localized()
            }
        }
        let d = c % 10
        if d == 0 { return "glasses".localized() }
        if d == 1 { return "glass".localized() }
        if d > 1 && d < 5 { return "glasses2".localized() }
        if d > 4 { return "glasses".localized() }
        return ""
    }
    
    @objc func leftSwipeAction(_ sender: UISwipeGestureRecognizer){
        nextMonthAction(UIButton())
    }
    
    @objc func rightSwipeAction(_ sender: UISwipeGestureRecognizer){
        prevMonthAction(UIButton())
    }
    
    @IBAction func periodButtonAction(_ sender: Any) {
        let periodView = PeriodPicker.loadFromNib()
        periodView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        periodView.delegate = self
        periodView.selectedDate = selectedPeriodDate
        self.tabBarController?.view.addSubview(periodView)
        
        UIView.animate(withDuration: 0.3) {
            periodView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }
    }
    
    @IBAction func prevMonthAction(_ sender: Any) {
        let date = selectedPeriodDate //calendView.currentDate
        let cal = Calendar.init(identifier: .gregorian)
        if let d = cal.date(byAdding: .month, value: -1, to: date) {
            selectedPeriodDate = d.startOfMonth()
//            calendView.changeMonth()
        }
        updateTopButtons()
    }
    
    @IBAction func nextMonthAction(_ sender: Any) {
        let date = selectedPeriodDate//calendView.currentDate
        let cal = Calendar.init(identifier: .gregorian)
        if let d = cal.date(byAdding: .month, value: 1, to: date) {
            if !d.monthMoreThen(date: Date()) {
                selectedPeriodDate = d.startOfMonth()
//                calendView.changeMonth()
            }
        }
        updateTopButtons()
    }
    
    func updateTopButtons(){
        let date = selectedPeriodDate //calendView.currentDate
        
        let year = Date().year() != date.year() ? " \(date.year())" : ""
        monthLabel.text = date.monthString() + year
        
        let cal = Calendar.init(identifier: .gregorian)
        if let d = cal.date(byAdding: .month, value: -1, to: date) {
            let year = Date().year() != d.year() ? " \(d.year())" : ""
            prevMonthBtn.setTitle(d.monthString() + year, for: .normal)
        }
        if let d = cal.date(byAdding: .month, value: 1, to: date) {
            let year = Date().year() != d.year() ? " \(d.year())" : ""
            nextMonthBtn.isEnabled = !d.monthMoreThen(date: Date())
            nextMonthBtn.setTitle(d.monthString() + year, for: .normal)
        }
        calculateInfo()
    }
    
    
}


extension StatisticsViewController: PeriodPickerDelegate {
    func didSelectDate(date: Date) {
        print(date)
        selectedPeriodDate = date
        calculateInfo()
    }
}
