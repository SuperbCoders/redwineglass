//
//  SettingsViewController.swift
//  Wine
//
//  Created by toxa on 4/30/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let sectionList:[Int:[String]] = [0: ["Term of Use", "Privacy Policy"],
                                      1: ["Send Feedback", "Visit Website", "Delete all data"]]
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        configTable()
    }
    
    func configTable(){
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
    }
    
    //MARK: table
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let text = section == 0 ? "Documentation" : "Community"
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 64.0)
        view.backgroundColor = .clear
        
        let lab = UILabel()
        lab.frame = CGRect(x: 17, y: 23, width: tableView.bounds.width - 20, height: 30)
//        lab.layer.borderWidth = 1
        lab.font = UIFont(name: "SFProText-Semibold", size: 12)
        lab.text = text.uppercased()
        lab.textColor = UIColor.hex("#405360")
        view.addSubview(lab)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionList[indexPath.section]?[indexPath.row] ?? ""
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 1 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1 {
           cell.textLabel?.textColor = UIColor.hex("#FB6D5B")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cornerRadius : CGFloat = 12.0
        cell.backgroundColor = UIColor.clear
        let layer: CAShapeLayer = CAShapeLayer()
        let pathRef:CGMutablePath = CGMutablePath()
        let bounds: CGRect = cell.bounds.insetBy(dx:0,dy:0)
        var addLine: Bool = false
        
        if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
            pathRef.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if (indexPath.row == 0) {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.midY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.maxY) )
            addLine = true
        } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY), transform: CGAffineTransform())
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.minY) )
        } else {
            pathRef.addRect(bounds)
            addLine = true
        }
        
        layer.path = pathRef
        layer.fillColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8).cgColor
        
        if (addLine == true) {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
            lineLayer.frame = CGRect(x:bounds.minX + 10 , y:bounds.size.height-lineHeight, width:bounds.size.width-10, height:lineHeight)
            lineLayer.backgroundColor = tableView.separatorColor?.cgColor
            layer.addSublayer(lineLayer)
        }
        
        let testView: UIView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = UIColor.clear
        cell.backgroundView = testView
        
//        let shadows = UIView()
//        shadows.frame = view.frame
//        shadows.clipsToBounds = false
////        view.addSubview(shadows)
//
//        let shadowPath0 = UIBezierPath(roundedRect: testView.bounds, cornerRadius: 0)
//        let layer0 = CALayer()
//        layer0.shadowPath = shadowPath0.cgPath
//        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03).cgColor
//        layer0.shadowOpacity = 1
//        layer0.shadowRadius = 10
//        layer0.shadowOffset = CGSize(width: 0, height: 3)
//        layer0.bounds = testView.bounds
//        layer0.position = testView.center
//        cell.backgroundView!.layer.addSublayer(layer0)
//
//        let shapes = UIView()
//        shapes.frame = view.frame
//        shapes.clipsToBounds = true
////        view.addSubview(shapes)
//
//        let layer1 = CALayer()
//        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        layer1.bounds = shapes.bounds
//        layer1.position = shapes.center
//        shapes.layer.addSublayer(layer1)
        
        

        
    }
}
