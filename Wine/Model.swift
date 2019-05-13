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
        case .white:    return "White Wine"
        case .red:      return "Red Wine"
        case .rose:     return "Rose Wine"
        case .sparking: return "Sparking Wine"
        case .elsee:    return "Else"
        }
    }
    
    var shotName : String {
        switch self {
        case .white:    return "White"
        case .red:      return "Red"
        case .rose:     return "Rose"
        case .sparking: return "Sparking"
        case .elsee:    return "Else"
        }
    }
    
    var desc : String {
        switch self {
        case .white:    return "Young and tasty"
        case .red:      return "The classics"
        case .rose:     return "You know the thing"
        case .sparking: return "Сongratulations!"
        case .elsee:    return "Do it your way"
        }
    }
    
    var cost : Float {
        switch self {
        case .white:    return 0.0
        case .red:      return 0.0
        case .rose:     return 0.0
        case .sparking: return 0.0
        case .elsee:    return 0.0
        }
    }
    
    var color : UIColor {
        switch self {
        case .white:    return UIColor.hex("#FFFEF7")
        case .red:      return UIColor.hex("#C00000")
        case .rose:     return UIColor.hex("#FFB6B5")
        case .sparking: return UIColor.hex("#FFFABE")
        case .elsee:    return UIColor.hex("#D4FFA5")
        }
    }
    
    var imageBG : UIImage {
        switch self {
        case .white:    return UIImage(named: "whiteGlass")!
        case .red:      return UIImage(named: "redGlass")!
        case .rose:     return UIImage(named: "pinkGlass")!
        case .sparking: return UIImage(named: "yellowGlass")!
        case .elsee:    return UIImage(named: "greenGlass")!
        }
    }
    
    var selectedImageBG : UIImage {
        switch self {
        case .white:    return UIImage(named: "whiteGlass_s")!
        case .red:      return UIImage(named: "redGlass_s")!
        case .rose:     return UIImage(named: "pinkGlass_s")!
        case .sparking: return UIImage(named: "yellowGlass_s")!
        case .elsee:    return UIImage(named: "greenGlass_s")!
        }
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


