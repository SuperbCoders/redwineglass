//
//  StatisticView.swift
//  Wine
//
//  Created by toxa on 5/2/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class StatisticView: UIView {

    var items = [WineRecordItem](){
        didSet{
           setupViews()
        }
    }
//    let originalInfo:[String:Int] = ["White":18, "Red":32, "Rose":14, "Sparking":12, "Else":56]
    var originalInfo:[WineType:Int] = [WineType:Int]()
    var sortKeys:[WineType] = [.white, .white, .white, .white, .white]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
        dropShadow()
    }
    
    private func prettyArray(){
        var temp = [WineType:Int]()
        let list: [WineType] = [ .white, .red, .rose, .sparking, .elsee ]
        
        for (_, type) in list.enumerated() {
            let a = items.filter({ $0.wineType == type })
            if a.count > 0 {
                temp[type] = a.count
            }
        }
        originalInfo = temp
    }

    
    private func fillArray(){
        prettyArray()
        var sortedKeys = (originalInfo as NSDictionary).keysSortedByValue(using: #selector(NSNumber.compare(_:))) as! [WineType]
        if sortedKeys.count < 5  {
            let list: [WineType] = [ .white, .red, .rose, .sparking, .elsee ]
            for (_, type) in list.enumerated() {
                if !sortedKeys.contains(where: { $0 == type }){
                    sortedKeys.append(type)
                }
            }
        }
        
        sortKeys[0] = sortedKeys[0]
        sortKeys[1] = sortedKeys[3]
        sortKeys[2] = sortedKeys[4]
        sortKeys[3] = sortedKeys[2]
        sortKeys[4] = sortedKeys[1]
        
    }
    
    private func setupViews(){
        clearViews()
        fillArray()
        let sp:CGFloat = 13
        var x:CGFloat = 32
        let w:CGFloat = (bounds.width - 2*x - 4 * sp) / 5
        let h100:CGFloat = bounds.height - (14 + 4 + 8 + 18 + 15)
        let maxValue = Array(originalInfo.values).max() ?? 0

        for (_, key) in sortKeys.enumerated() {

            let val = originalInfo[key] ?? 0
            let hLine:CGFloat = val == 0 ? 3.0 : CGFloat(val) * h100 / CGFloat(maxValue)
            let dif = h100 - hLine
            let lineColor = val == maxValue ? UIColor.hex("#62C78B") : UIColor.hex("#B6B6B6")
            let lineAlpha:CGFloat = val == maxValue ? 1.0 : 0.4

            let numLab = UILabel(frame: CGRect(x: x, y: dif, width: w, height: 14))
            numLab.text = "\(val)"
            numLab.font = UIFont(name: "SFProText-Light", size: 11)
//            numLab.layer.borderWidth = 0.5
            numLab.textAlignment = .center
            numLab.textColor = UIColor.hex("#909BA4")
            self.addSubview(numLab)

            let line = UIView()
            line.frame = CGRect(x: x, y: numLab.frame.origin.y + numLab.frame.size.height + 4, width: w, height: hLine)
            line.layer.cornerRadius = 8.0
//            line.layer.borderWidth = 0.5
            line.backgroundColor = lineColor
            line.alpha = lineAlpha
            self.addSubview(line)

            let keyLab = UILabel(frame: CGRect(x: x, y: numLab.frame.origin.y + numLab.frame.size.height + 4 + hLine + 12, width: w, height: 18))
            keyLab.text = key.shotName
            keyLab.font = UIFont(name: "SFProText-Semibold", size: 13)
//            keyLab.layer.borderWidth = 0.5
            keyLab.textAlignment = .center
            keyLab.textColor = UIColor.hex("#405360")
            self.addSubview(keyLab)

            x += sp + w

        }

    }
    
    private func clearViews(){
        self.subviews.forEach { (v) in
            v.removeFromSuperview()
        }
    }
  
}
