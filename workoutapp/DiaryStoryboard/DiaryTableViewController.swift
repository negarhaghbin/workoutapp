//
//  DiaryTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class DiaryTableViewController: UIViewController{
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewLabel: UILabel!
    
    // MARK: - Variables
    
    lazy var diariesDict : [String:[DiaryItem]] = DiaryItem.getWithDate()
    lazy var steps : [String:[Step]] = Step.getWithDate()
    var dates : [String] = []
    let STEPS_ROW = 0
    let diaryCellIdentifier = "diaryCell"
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 100
        tabBarController?.tabBar.isHidden = false
        diariesDict = DiaryItem.getWithDate()
        steps = Step.getWithDate()
        if diariesDict.count > steps.count{
            dates = Array(diariesDict.keys).sorted(by: >)
        }
        else{
            dates = Array(steps.keys).sorted(by: >)
        }
        
        
        if diariesDict.count+steps.count > 1{
            viewLabel.text = "Tap on an exercise to edit"
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDiaryItem", let destination = segue.destination as? NewWorkoutPopupViewController {
            if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) {
                let diaryItem = diariesDict[dates[indexPath.section]]![indexPath.row-1]
                destination.diaryItem = diaryItem
                destination.boxTitle.text = "Edit workout"
            }
        }
    }
    
}

// MARK: - TableViewDataSource and TableViewDelegate

extension DiaryTableViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: diaryCellIdentifier, for: indexPath) as? DiaryTableViewCell
        else{
            return DiaryTableViewCell()
        }
        
        if indexPath.row == STEPS_ROW{
            cell.setValues(isStepCell: true, stepsCount: steps[dates[indexPath.section]])
        }
        else{
            cell.setValues(isStepCell: false, diaryItem: diariesDict[dates[indexPath.section]]![indexPath.row-1])
        }
        return cell
        
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
        return indexPath.row == STEPS_ROW ? false : true
    }
    

}
