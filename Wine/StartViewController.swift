//
//  StartViewController.swift
//  Wine
//
//  Created by toxa on 5/4/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startAction(_ sender: Any) {
    
        UserDefaults.standard.set("alreadyStart", forKey: "alreadyStart")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tbc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        self.present(tbc, animated: true, completion: nil)
        
    }

}
