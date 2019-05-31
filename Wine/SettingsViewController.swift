//
//  SettingsViewController.swift
//  Wine
//
//  Created by toxa on 4/30/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let termsUrl = "https://www.google.com"
    let policyUrl = "https://www.google.com"
    let visitUrl = "http://roboapps.co/redwineglass/"
    let feedbackMail = "hi@roboapps.co"
    
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var visitLabel: UILabel!
    @IBOutlet weak var sendLabel: UILabel!
    @IBOutlet weak var comLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var docLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thridLineHeight: NSLayoutConstraint!
    @IBOutlet weak var secondLineHeight: NSLayoutConstraint!
    @IBOutlet weak var firstLineHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    let sectionList:[Int:[String]] = [0: ["Term of Use", "Privacy Policy"],
                                      1: ["Send Feedback", "Visit Website", "Delete all data"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let custom = UIView(frame: CGRect(x: 0, y: 98, width: self.view.bounds.width, height: self.view.bounds.height - 98 - 84))
        custom.backgroundColor = UIColor.hex("#FCFBF8")
        self.view.insertSubview(custom, at: 0)
        
        titleLabel.text = "Settings".localized()
        docLabel.text = "DOCUMENTATION".localized()
        termsLabel.text = "Term of Use".localized()
        policyLabel.text = "Privacy Policy".localized()
        comLabel.text = "COMMUNITY".localized()
        visitLabel.text = "Visit Website".localized()
        sendLabel.text = "Send Feedback".localized()
        deleteLabel.text = "Delete all data".localized()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    
    func setupView(){
        
        firstLineHeight.constant = (1.0 / UIScreen.main.scale)
        secondLineHeight.constant = (1.0 / UIScreen.main.scale)
        thridLineHeight.constant = (1.0 / UIScreen.main.scale)
        
        topView.layer.cornerRadius = 15
        bottomView.layer.cornerRadius = 15
        
        addShadow(parent: topView)
        addShadow(parent: bottomView)
    }
    
    @IBAction func termsAction(_ sender: Any) {
        guard let url = URL(string: termsUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func policyAction(_ sender: Any) {
        guard let url = URL(string: policyUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func visitAction(_ sender: Any) {
        guard let url = URL(string: visitUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func feedBackAction(_ sender: Any) {
        let email = feedbackMail
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "Warning".localized(), message: "Are you sure delete all data?".localized(), preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: "Yes".localized(), style: UIAlertAction.Style.default, handler: { (but) in
                RouterDB.shared.resetItems()
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.destructive, handler: { (but) in
                alert.dismiss(animated: true, completion: nil)
            }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addShadow(parent:UIView){
        parent.layer.masksToBounds = false
        parent.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
        parent.layer.shadowOpacity = 1
        parent.layer.shadowOffset = CGSize(width: 0, height: 6)
        parent.layer.shadowRadius = 6
        parent.layer.shadowPath = UIBezierPath(rect: parent.bounds).cgPath
        parent.layer.shouldRasterize = true
        parent.layer.rasterizationScale = UIScreen.main.scale
    }

}
