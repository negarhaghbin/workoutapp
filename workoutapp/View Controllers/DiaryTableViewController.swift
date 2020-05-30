//
//  DiaryTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class DiaryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewLabel: UILabel!
    lazy var diariesDict : [String:[DiaryItem]] = DiaryItem.getWithDate()
    var dates : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 100
        diariesDict = DiaryItem.getWithDate()
        dates = Array(diariesDict.keys).sorted(by: >)
        
        if diariesDict.count > 0{
            viewLabel.text = "Tap to edit."
        }
        tableView.reloadData()
    }
    
    
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return diariesDict.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diariesDict[dates[section]]!.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath) as? DiaryTableViewCell{
            cell.nameLabel.text = diariesDict[dates[indexPath.section]]![indexPath.row].exercise?.name
            let duration = diariesDict[dates[indexPath.section]]![indexPath.row].duration
            cell.durationLabel.text = duration?.getDuration()
            if diariesDict[dates[indexPath.section]]![indexPath.row].exercise?.name == "Steps"{
                cell.isUserInteractionEnabled = false
                cell.durationLabel.isEnabled = false
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDiaryItem", let destination = segue.destination as? NewWorkoutPopupViewController {
            if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) {
                let diaryItem = diariesDict[dates[indexPath.section]]![indexPath.row]
                destination.diaryItem = diaryItem
            }
        }
    }
    

}
