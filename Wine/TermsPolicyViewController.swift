//
//  TermsPolicyViewController.swift
//  Wine
//
//  Created by toxa on 6/2/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class TermsPolicyViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    var isTerms:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = isTerms ? "Term of Use" : "Privacy Policy"
        let fileName = isTerms ? "terms_and_conditions" : "privacy_policy"
        
        let str = try! String(contentsOfFile: Bundle.main.path(forResource: fileName, ofType: "md")!, encoding: .utf8)
        textView.text = str
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
