//
//  SettingsTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-08.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift

struct SettingsSection{
    var title: String
}

class SettingsTableViewController: UITableViewController {
    //lazy var users: Results<User> = { self.realm.objects(User.self) }()
    
    
    let SettingsCellReuseIdentifier = "SettingsTableViewCell"
    let UserCellReuseIdentifier = "UserTableViewCell"
    var sections : [SettingsSection] = []
    var user : User = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSections()
        initUser()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func initSections(){
        let titles=["General", "Notifications"]
        for title in titles{
            sections.append(SettingsSection(title: title))
        }
        //TODO: initialize section
    }
    
    func initUser(){
        let specificPerson = try! Realm().object(ofType: UserModel.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))
        user.name=specificPerson!.name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1){
           guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCellReuseIdentifier, for: indexPath) as? SettingsTableViewCell
            else {
                    return SettingsTableViewCell()
            }
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCellReuseIdentifier, for: indexPath) as? UserTableViewCell
                
            else{
                return UserTableViewCell()
            }
            cell.name.text=user.name
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "NameSegue", sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let vc = segue.destination as? NameTableViewController{
            vc.user = user
        }
        // Pass the selected object to the new view controller.
    }
    

}
