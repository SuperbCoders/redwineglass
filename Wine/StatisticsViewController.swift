//
//  StatisticsViewController.swift
//  Wine
//
//  Created by toxa on 4/30/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var statsView: StatisticView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var countlabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var periodButton: UIButton!
    private var selectedPeriodDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateInfo()
    }
    
    private func calculateInfo(){
        
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        let monthText = df.string(from: selectedPeriodDate)
        
        let endMonth = selectedPeriodDate.endOfMonth()
        let last = endMonth > Date() ? Date() : endMonth
        
        df.dateFormat = "d"
        
        let text = "1st of " + monthText + " — " + df.string(from: last) + "st of " + monthText
        periodButton.setTitle(text, for: .normal)
        
        let items = RouterDB.shared.getWineItems(startDate: selectedPeriodDate.startOfMonth(), endDate: last)
        
        countlabel.text = "\(items.count) glasses"
        averageLabel.text = String(format: "%0.1f glasses daily", Float(items.count) / Float(df.string(from: last))!)
        
        statsView.items = items
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
    
}


extension StatisticsViewController: PeriodPickerDelegate {
    func didSelectDate(date: Date) {
        print(date)
        selectedPeriodDate = date
        calculateInfo()
    }
}
