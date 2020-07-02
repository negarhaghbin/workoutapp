//
//  DiaryTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import HealthKit

class DiaryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewLabel: UILabel!
    lazy var diariesDict : [String:[DiaryItem]] = DiaryItem.getWithDate()
    lazy var steps : [String:[Step]] = Step.getWithDate()
    var dates : [String] = []
    let STEPS_ROW = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 100
        diariesDict = DiaryItem.getWithDate()
        steps = Step.getWithDate()
        if diariesDict.count > steps.count{
            dates = Array(diariesDict.keys).sorted(by: >)
        }
        else{
            dates = Array(steps.keys).sorted(by: >)
        }
        
        
        if diariesDict.count+steps.count > 0{
            viewLabel.text = "Tap to edit."
        }
        tableView.reloadData()
    }
    
    
    

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return max(diariesDict.count, steps.count)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let specifiedDateWorkouts = diariesDict[dates[section]]{
            if let specifiedDateSteps = steps[dates[section]]{
                return (specifiedDateWorkouts.count + specifiedDateSteps.count)
            }
            else{
                return specifiedDateWorkouts.count + 1 //showing steps row anyways
            }
        }
        else{
            return 1
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath) as? DiaryTableViewCell{
            if indexPath.row == STEPS_ROW{
                cell.nameLabel.text = "Steps"
                if let step = steps[dates[indexPath.section]] {
                    if step.first!.count == -1{
                        cell.durationLabel.text = "Not Available"
                    }
                    else{
                        cell.durationLabel.text = String(step.first!.count)
                    }
                }
                else{
                    cell.durationLabel.text = "Not Available"
                }
                
                cell.isUserInteractionEnabled = false
                cell.durationLabel.isEnabled = false
            }
            else{
                cell.nameLabel.text = diariesDict[dates[indexPath.section]]![indexPath.row-1].exercise?.name
                let duration = diariesDict[dates[indexPath.section]]![indexPath.row-1].duration
                cell.durationLabel.text = duration?.getDuration()
            }
            
            return cell
        }
        else{
            return DiaryTableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dates[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row != STEPS_ROW{
            if editingStyle == .delete {
                diariesDict[dates[indexPath.section]]![indexPath.row-1].delete()
                diariesDict[dates[indexPath.section]]!.remove(at: indexPath.row-1)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == STEPS_ROW{
            return false
        }
        else{
            return true
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDiaryItem", let destination = segue.destination as? NewWorkoutPopupViewController {
            if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) {
                let diaryItem = diariesDict[dates[indexPath.section]]![indexPath.row-1]
                destination.diaryItem = diaryItem
            }
        }
    }
    

}
