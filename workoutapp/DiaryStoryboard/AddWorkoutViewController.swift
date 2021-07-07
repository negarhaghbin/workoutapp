//
//  AddWorkoutViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-04-24.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit


class AddWorkoutViewController: UIViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Variables
    var sections : [RoutineSection] = RoutineSection.getRoutineSections()
    let cellIdentifier = "addWorkoutCell"
    weak var delegate: ExerciseSelectionDelegate?
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? AddWorkoutTableCell{
            let indexPath = self.tableView!.indexPath(for: cell)
            if indexPath?.section != 0 && segue.identifier == "oldWorkout" {
                let vc = segue.destination as! NewWorkoutPopupViewController
                let exercise = sections[indexPath!.section-1].exercises[indexPath!.row]
                let diaryItem = DiaryItem(e: exercise.exercise, d: Duration(durationInSeconds: exercise.durationInSeconds?.durationInSeconds))
                vc.diaryItem = diaryItem
            }
        }
        else if (sender as? UIButton) != nil{
            performSegue(withIdentifier: "newWorkout", sender: nil)
        }
    }
}

extension AddWorkoutViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (sections.count + 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
           return sections[section-1].exercises.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }
        else{
           return sections[section-1].title
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddWorkoutTableCell
            else{
                return AddWorkoutTableCell()
        }
        
        if indexPath.section == 0{
            cell.setValues(isWorkout: false)
        }
        else{
            let exercise = sections[indexPath.section-1].exercises[indexPath.row]
            cell.setValues(isWorkout: true, exercise: exercise)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat(75)
        }
        else{
            return CGFloat(150)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0{
            let selectedExercise = sections[indexPath.section-1].exercises[indexPath.row]
            delegate?.exerciseSelected(selectedExercise)
        }
        
    }
}
