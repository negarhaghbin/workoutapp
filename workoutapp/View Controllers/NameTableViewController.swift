//
//  NameTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-10.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift

class NameTableViewController: UITableViewController {
    
    var user : User = User()

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField?.text=user.name
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            textField.becomeFirstResponder()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func changeName(_ sender: Any) {
        let specificPerson = User.getUser(uuid: UserDefaults.standard.string(forKey: "uuid")!)
        specificPerson.changeName(newName: textField.text!)
         _ = navigationController?.popViewController(animated: true)
    }
}
