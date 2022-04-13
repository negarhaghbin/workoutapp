//
//  NameTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-10.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class NameTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField!

    // MARK: - Variables
    
    var user : User = User()
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField?.text=user.name
    }
    
    // MARK: - TableViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            textField.becomeFirstResponder()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func changeName(_ sender: Any) {
        guard let uuid = UserDefaults.standard.string(forKey: "uuid") else {return}
        let specificPerson = User.getUser(uuid: uuid)
        specificPerson.changeName(newName: textField.text!)
        navigationController?.popViewController(animated: true)
    }
}
