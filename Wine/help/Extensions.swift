//
//  Extensions.swift
//  Wine
//
//  Created by toxa on 4/30/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    static func hex(_ hexString:String) -> UIColor{
        var hex = hexString
        
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }
        
        guard let hexVal = Int(hex, radix: 16) else {
            return UIColor.black
        }
        
        return UIColor.init(red:   CGFloat( (hexVal & 0xFF0000) >> 16 ) / 255.0,
                            green: CGFloat( (hexVal & 0x00FF00) >> 8 ) / 255.0,
                            blue:  CGFloat( (hexVal & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(1.0))
        
    }
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}

extension Date {

    func isEqual(date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: self) == dateFormatter.string(from: date)
    }
    
    func monthMoreThen(date: Date) -> Bool {
        if self.year() != date.year() {
            return self.year() > date.year()
        }
        return self.month() > date.month()
    }
    
    func month() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    func year() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY"
        
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    func startOfMonth() -> Date {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func toString(format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func today() -> Date {
        return Date()
    }
    
    func dayOfDate()->Int{
        let cal = Calendar.init(identifier: .gregorian)
        let comp = cal.dateComponents([.day], from: self)
        return comp.day!
    }
    
    func isNextMonthFrom(date:Date) -> Bool{
        let cal = Calendar.init(identifier: .gregorian)
        let comp1 = cal.dateComponents([.year, .month], from: self)
        let comp2 = cal.dateComponents([.year, .month], from: date)
        return comp1.year == comp2.year && comp1.month == (comp2.month! + 1)
    }
    
    func isSameMonth(date:Date) -> Bool{
        
        let cal = Calendar.init(identifier: .gregorian)
        let comp1 = cal.dateComponents([.year, .month], from: self)
        let comp2 = cal.dateComponents([.year, .month], from: date)
        
        return comp1.year == comp2.year && comp1.month == comp2.month
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    
//    Date.today().previous(.sunday)
//    Date.today().previous(.monday)
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 0
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
    
}

extension UIViewController {
    
    func showToast(message : String, duration:TimeInterval, y:CGFloat?) {
        
        let frameY = y != nil ? y! : self.view.frame.size.height / 2 - 35.0/2
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: frameY, width: 180, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "SFProText-Semibold", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 2
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

extension UIView {
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowRadius = 6
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}


public protocol NibLoadable: class {
    static var nib: UINib { get }
}

public extension NibLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
public extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}


