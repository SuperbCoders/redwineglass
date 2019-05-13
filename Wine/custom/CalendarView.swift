//
//  CalendarView.swift
//  Wine
//
//  Created by toxa on 4/30/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate : class {
    func didDayTap(_ date: Date)
}

@IBDesignable
class CalendarView: UIView/*, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout */ {
    
    
    var contentView:UIView?
    @IBInspectable var nibName:String?
    
    private var labelList = [UILabel]()
    private var dayList = [UIView]()
    private var dateList = [Date]()
    private var prevMonthDate = Date()
    private var nextMonthDate = Date()
    
    private var currentDaySelector: CALayer =  {
       let layer = CALayer()
        
        return layer
    }()
    
    var currentDate = Date()
    var selectedDay = Date()
    weak var delegate: CalendarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        xibSetup()
        backgroundColor = .clear
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
        currentDaySelector.removeFromSuperlayer()
        
    }
    
    private func calcutateDays(){

        let calendar = Calendar.current //(identifier: .gregorian)
        var first = currentDate.startOfMonth()
        let end = currentDate.endOfMonth()
        
        if let d = calendar.date(byAdding: .day, value: -1, to: first) {
            first = d//.startOfMonth()
        }
        
        var uniqueDates = [Date]()
        
        var cur = first
        while cur < end {
            let today = calendar.startOfDay(for: cur)
            let dayOfWeek = calendar.component(.weekday, from: today) - calendar.firstWeekday //calendar.component(.weekday, from: today) - 1
            let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
//            print(dayOfWeek, weekdays.lowerBound, weekdays.upperBound)
            let days = (weekdays.lowerBound ..< weekdays.upperBound).compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            days.forEach { (d) in
                if !uniqueDates.contains(d) {
                    uniqueDates.append(d)
                }
            }
            if let d = calendar.date(byAdding: .day, value: 1, to: cur) {
                cur = d
            }else{
                break
            }
        }
        
//        uniqueDates.forEach { (d) in
//            print(d, d.dayOfDate())
//        }
        
        dateList = uniqueDates
        
    }
    
    func changeMonth(){
        setupViews()
    }
    
    private func setupViews(){
        
        clearAll()
        
        calcutateDays()
        setupHeader()
        setupDays()
    }
    
    private func setupHeader(){
        
        let cal = Calendar(identifier: .gregorian)
        let firstWeekday = 2 // -> Monday(2) or Sun(1)
        var symbols = cal.weekdaySymbols
        symbols = Array(symbols[firstWeekday-1..<symbols.count]) + symbols[0..<firstWeekday-1]

        // week labels
        var x:CGFloat = 15.0
        let y:CGFloat = 0.0
        let w:CGFloat = (bounds.width - 2 * x) / 7.0
        let h:CGFloat = 24.0
        for i in 0..<7 {
            let lab = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
            lab.text = symbols[i].uppercased()
            lab.font = UIFont(name: "SFProText-Light", size: 13)
            //            lab.layer.borderWidth = 0.5
            lab.textAlignment = .center
            lab.textColor = UIColor.hex("#B6B6B6")
            self.addSubview(lab)
            labelList.append(lab)
            x += w
        }
    }
    
    private func setupDays(){
        clearAll()
        let start:CGFloat = 15
        var x:CGFloat = start
        var y:CGFloat = 24
        let w:CGFloat = (bounds.width - 2 * x) / 7.0
        let h:CGFloat = w
        
        for i in 0..<dateList.count {
            let v = UIView(frame: CGRect(x: x, y: y, width: w, height: h))
            v.tag = i
//            v.layer.borderWidth = 0.5
            
            let dat = dateList[i]
            let text = dat.dayOfDate()
            let items = RouterDB.shared.getWineItems(date: dat)
            
            var name = "glass"
            var textColor = UIColor.hex("#405360")
            
            if !currentDate.isSameMonth(date: dat) {
                name = "glassGray"
                textColor = UIColor.hex("#B6B6B6")
            }
            
            let imgW = w - 20
            let img = UIImageView(image: UIImage(named: name))
            img.tag = 11
            img.frame = CGRect(x: (w - imgW)/2.0, y: (h - imgW)/2.0, width: imgW, height: imgW)
            //            img.layer.borderWidth = 0.5
            v.addSubview(img)
            
            let lab = UILabel(frame: CGRect(x: w - 15, y: 0, width: 15, height: 15))
            lab.text = "\(text)"
            lab.font = UIFont(name: "SFProText-Regular", size: 10)
            //            lab.layer.borderWidth = 0.5
            lab.textAlignment = .center
            lab.textColor = textColor
            
            if items.count >= 2 {
                lab.backgroundColor = UIColor.hex("#7894D7")
                lab.textColor = .white
                lab.text = "\(items.count)"
                lab.font = UIFont(name: "SFProText-Bold", size: 10)
                lab.layer.cornerRadius = lab.bounds.width / 2
                lab.clipsToBounds = true
            }
            
            if items.count == 1 {
                if dat.isEqual(date: selectedDay) {
                    img.image = items.first!.wineType.selectedImageBG
                }else{
                   img.image = items.first!.wineType.imageBG
                }
            }
            
            v.addSubview(lab)
            labelList.append(lab)
            
            self.addSubview(v)
            dayList.append(v)
            x += w
            if (i+1) % 7 == 0 && i > 0 {
                y += h
                x = start
            }
            if dat.isEqual(date: selectedDay) {
                delay(0.2) {
                    v.layer.insertSublayer(self.currentDaySelector, at: 0)
                }
                currentDaySelector.frame = CGRect(x: 0, y: 0, width: w, height: h)
                currentDaySelector.backgroundColor = UIColor.hex("#FB6D5B").cgColor
                currentDaySelector.cornerRadius = w / 2
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
            tap.numberOfTapsRequired = 1
            v.isUserInteractionEnabled = true
            v.addGestureRecognizer(tap)
            
        }
    }
    
    @objc private func didTap(_ gest:UITapGestureRecognizer){
        if let view = gest.view{
            let dat = dateList[view.tag]
            self.selectedDay = dat
            delegate?.didDayTap(dat)
            view.layer.insertSublayer(self.currentDaySelector, at: 0)
            
            setupDays()
        }
    }
    
    private func clearAll(){
        labelList.forEach { (lab) in
            lab.removeFromSuperview()
        }
        labelList.removeAll()
        
        dayList.forEach { (lab) in
            lab.removeFromSuperview()
        }
        dayList.removeAll()
    }
    
}

