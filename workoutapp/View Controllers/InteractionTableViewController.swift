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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InteractionTableCell", for: indexPath) as? InteractionTableViewCell
        else{
                return InteractionTableViewCell()
        }
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            cell.dateLabel.text = routineHistory[indexPath.row].dateString
            cell.identityLabel.text = getAllSeconds()[indexPath.row]
        case 1:
            cell.dateLabel.text = interactions[indexPath.row].dateString
            cell.identityLabel.text = interactions[indexPath.row].identifier
        default:
            print("unknown value")
        }

        return cell
    }
    
    func getAllSeconds()->[String]{
        var results : [String] = []
        for DR in routineHistory{
            var temp =  DR.absSeconds + DR.lowerBodySeconds + DR.totalBodySeconds + DR.upperBodySeconds
            results.append(String(temp))
        }
        return results
    }

    @IBAction func segmentTapped(_ sender: Any) {
//        switch segmentController.selectedSegmentIndex {
//        case 0:
//            data = dailyRoutine.getDictionary()
//            for title in titles{
//                let percentage = (Float(data[title]!)*100.0)/(2*60.0)
//                percentages.append(percentage)
//            }
//        case 1:
//            data = dailyRoutine.getAllDictionary()
//            for title in titles{
//                totalTime.append(Float(data[title]!))
//            }
//            max = Int(totalTime.max()!)
//
//        default:
//            print("not familiar segment")
//        }
        tableView.reloadData()
        //reloadProgress(index: index)
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
