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
        if let cell = sender as? AddWorkoutTableCell {
            if let indexPath = self.tableView.indexPath(for: cell), indexPath.section != 0, segue.identifier == SegueIdentifiers.oldWorkout {
                if let vc = segue.destination as? NewWorkoutPopupViewController {
                    let exercise = sections[indexPath.section-1].exercises[indexPath.row]
                    let diaryItem = DiaryItem(e: exercise.exercise, d: Duration(durationInSeconds: exercise.durationInSeconds?.durationInSeconds))
                    vc.diaryItem = diaryItem
                }
            }
        } else if let _ = sender as? UIButton {
            performSegue(withIdentifier: SegueIdentifiers.newWorkout, sender: nil)
        }
    }
}


// MARK: - UITable

extension AddWorkoutViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (sections.count + 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : sections[section-1].exercises.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "" : sections[section-1].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.addWorkoutCell, for: indexPath) as? AddWorkoutTableCell else{ return AddWorkoutTableCell() }
        
        if indexPath.section == 0 {
            cell.setValues(isWorkout: false)
        } else {
            let exercise = sections[indexPath.section-1].exercises[indexPath.row]
            cell.setValues(isWorkout: true, exercise: exercise)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? CGFloat(75) : CGFloat(150)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let selectedExercise = sections[indexPath.section-1].exercises[indexPath.row]
            delegate?.exerciseSelected(selectedExercise)
        }
    }
}
