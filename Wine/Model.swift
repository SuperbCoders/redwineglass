//
//  Model.swift
//  Wine
//
//  Created by toxa on 5/4/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import Foundation
import UIKit

enum WineType: Int {
    case white
    case red
    case rose
    case sparking
    case elsee
    
    var name : String {
        switch self {
        case .white:    return "White Wine".localized()
        case .red:      return "Red Wine".localized()
        case .rose:     return "Rose Wine".localized()
        case .sparking: return "Sparking Wine".localized()
        case .elsee:    return "Else".localized()
        }
    }
    
    var shotName : String {
        switch self {
        case .white:    return "White".localized()
        case .red:      return "Red".localized()
        case .rose:     return "Rose".localized()
        case .sparking: return "Sparking".localized()
        case .elsee:    return "Else".localized()
        }
    }
    
    var desc : String {
        switch self {
        case .white:    return "Young and tasty".localized()
        case .red:      return "The classics".localized()
        case .rose:     return "You know the thing".localized()
        case .sparking: return "Сongratulations!".localized()
        case .elsee:    return "Do it your way".localized()
        }
    }
    
    var cost : Float {
        switch self {
        case .white:    return 1000.0
        case .red:      return 1100.0
        case .rose:     return 1200.0
        case .sparking: return 1300.0
        case .elsee:    return 1400.0
        }
    }
    
    var color : UIColor {
        switch self {
        case .white:    return UIColor.hex("#FFFEF6")
        case .red:      return UIColor.hex("#C00000")
        case .rose:     return UIColor.hex("#FFB6B5")
        case .sparking: return UIColor.hex("#FFFABE")
        case .elsee:    return UIColor.hex("#A3D6F3")
        }
    }
    
    var imageBG : UIImage {
        switch self {
        case .white:    return UIImage(named: "white_glass2")! //UIImage(named: "white_glass")!
        case .red:      return UIImage(named: "red_glass")!
        case .rose:     return UIImage(named: "pink_glass")!
        case .sparking: return UIImage(named: "yellow_glass")!
        case .elsee:    return UIImage(named: "green_glass")!
        }
    }
    
    var selectedImageBG : UIImage {
        switch self {
        case .white:    return UIImage(named: "white_glass2_s")! //UIImage(named: "white_glass_s")!
        case .red:      return UIImage(named: "red_glass_s")!
        case .rose:     return UIImage(named: "pink_glass_s")!
        case .sparking: return UIImage(named: "yellow_glass_s")!
        case .elsee:    return UIImage(named: "green_glass_s")!
        }
    }
    
    static var doubleGlassImg : UIImage {
        return UIImage(named: "double_glass")!
    }
    static var selectedDoubleGlassImg : UIImage {
        return UIImage(named: "double_glass_s")!
    }
    
}

class WineRecordItem: NSObject, NSCoding {
    
    var dateString: String
    var date: Date
    var wineType = WineType.white
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.dateString, forKey: "dateString")
        aCoder.encode(self.date, forKey: "date")
        let i = "\(self.wineType.rawValue)"
        aCoder.encode(i, forKey: "wineType")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(dateString: "", date: Date(), wineType: .white)
        self.dateString = aDecoder.decodeObject(forKey: "dateString") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        let i = aDecoder.decodeObject(forKey: "wineType") as! String
        self.wineType = WineType(rawValue: Int(i) ?? 0)!
    }
    
    init(dateString:String, date:Date, wineType:WineType) {
        self.dateString = dateString
        self.date = date
        self.wineType = wineType
    }
    init(dict:[String:Any]) {
        self.dateString = ""
        self.date = Date()
        self.wineType = .white
        assertionFailure("fill params")
    }
}

class RouterDB: NSObject {
    static let dbkey = "WineDataBase"
    static let dbDateFormat = "dd.MM.yy"
    static let shared: RouterDB = {
        let instance = RouterDB()
        return instance
    }()

    var items:[WineRecordItem] = [WineRecordItem]()
    
    func initDefaults(){
        loadWineItems()
    }
    
    func getWineItems(date:Date)->[WineRecordItem]{
        let dateStr = date.toString(format: RouterDB.dbDateFormat)
        let filtered = items.filter({$0.dateString == dateStr})
        return filtered
    }
    
    func loadWineItems(){
        if let data = UserDefaults.standard.object(forKey: RouterDB.dbkey) as? Data {
            if let list = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [WineRecordItem] {
                items = list
            }
        }
        printItems()
    }
    
    func saveWineItems(){
        let data = NSKeyedArchiver.archivedData(withRootObject: items)
        UserDefaults.standard.set(data, forKey: RouterDB.dbkey)
    }
    
    func addItem(item: WineRecordItem){
        items.append(item)
        saveWineItems()
    }
    
    func deleteItems(itms:[WineRecordItem]){
        itms.forEach { (item) in
            if let ind = items.firstIndex(of: item) {
                items.remove(at: ind)
            }
        }
    }
    
    func resetItems(){
        UserDefaults.standard.removeObject(forKey: RouterDB.dbkey)
        items.removeAll()
    }
    
    private func printItems(){
        items.forEach { (item) in
            print(item.dateString, item.wineType.rawValue)
        }
    }
    
}


extension RouterDB {
    
    func getWineItems(startDate:Date, endDate:Date)->[WineRecordItem]{
        let filtered = items.filter({$0.date >= startDate && $0.date <= endDate})
        return filtered
    }
    
}

extension WineRecordItem {
    static func isSameOfItems(itms:[WineRecordItem]) -> Bool{
        if itms.count < 2 {
            return true
        }
        let temp = itms[0].wineType
        for w in itms {
            if w.wineType != temp {
                return false
            }
        }
        return true
    }
}


