//
//  NavViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit


class NavViewController: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNewUser() {
            askName()
        }
    }
    
    func isNewUser() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            return false
        }
        return true
    }
        
    
    func askName() {
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Awsome me"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            User(name: "Awsome me").add()
        }))

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                User(name: name).add()
            }
        }))
        
        present(alert, animated: true)
    }
}
