//
//  NavViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift


class NavViewController: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        if isNewUser(){
            askName()
        }
            
    }
    
    func isNewUser()->Bool{
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            return false
        }
        return true
    }
        
    
    func askName(){
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Awsome me"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            User.createUser(name: "Awsome me")
        }))

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                User.createUser(name: name)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

    
}
