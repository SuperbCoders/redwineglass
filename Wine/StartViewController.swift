//
//  StartViewController.swift
//  Wine
//
//  Created by toxa on 5/4/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.setTitle("Let’s Start".localized(), for: .normal)
        titleLabel.text = "Mark the days when\nyou drink wine".localized()
        descLabel.text = "Watch your habits and make\nconclusions".localized()
    }
    
    @IBAction func startAction(_ sender: Any) {
    
        UserDefaults.standard.set("alreadyStart", forKey: "alreadyStart")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tbc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        self.present(tbc, animated: true, completion: nil)
        
    }

}
