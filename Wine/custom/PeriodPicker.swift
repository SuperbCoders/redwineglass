//
//  PeriodPicker.swift
//  Wine
//
//  Created by toxa on 5/2/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

protocol PeriodPickerDelegate: class {
    func didSelectDate(date: Date)
}

class PeriodPicker: UIView, NibLoadable {

    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: PeriodPickerDelegate?
    var selectedDate:Date = Date()
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.maximumDate = Date()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        datePicker.date = selectedDate
    }

    @IBAction func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @IBAction func doneAction(_ sender: Any) {
        delegate?.didSelectDate(date: selectedDate)
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.bounds.height)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
