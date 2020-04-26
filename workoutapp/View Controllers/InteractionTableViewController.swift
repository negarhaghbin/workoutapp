//
//  InteractionTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-01-14.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import RealmSwift

class InteractionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var interactions : [Interaction] = Interaction.getAll()
    var routineHistory : [dailyRoutine] = dailyRoutine.getAll()
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentController.selectedSegmentIndex {
        case 0:
            return routineHistory.count
        case 1:
            return interactions.count
        default:
            print("unknown value")
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentController.selectedSegmentIndex {
        case 0:
            return routineHistory[section].dateString
            
        case 1:
            return interactions[section].dateString
        default:
            print("unknown value")
        }
        return ""
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InteractionTableCell", for: indexPath) as? InteractionTableViewCell
        else{
                return InteractionTableViewCell()
        }
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            cell.dateLabel.text = routineHistory[indexPath.section].exerciseType
            cell.identityLabel.text = "\(routineHistory[indexPath.section].seconds) s"
            
        case 1:
            cell.dateLabel.text = interactions[indexPath.section].identifier
        default:
            print("unknown value")
        }

        return cell
    }

    @IBAction func segmentTapped(_ sender: Any) {
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
