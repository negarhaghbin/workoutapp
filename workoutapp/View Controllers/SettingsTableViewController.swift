//
//  SettingsTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-08.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsTableViewController: UITableViewController {
    var user : User = User()
    
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initUser()
        userName.text=user.name
    }
    
    func initUser(){
        let specificPerson = try! Realm().object(ofType: UserModel.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))
        user.name=specificPerson!.name
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        if segue.identifier == "edit" {
            let vc = segue.destination as! NameTableViewController
            vc.user = user
        }
        
        // Pass the selected object to the new view controller.
    }
    

}
