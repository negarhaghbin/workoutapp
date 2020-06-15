//
//  AddWorkoutViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-04-24.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit


class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var sections : [RoutineSection] = RoutineSection.getRoutineSections()
    let cellIdentifier = "addWorkoutCell"
    weak var delegate: ExerciseSelectionDelegate?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].exercises.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddWorkoutTableCell
            else{
                return AddWorkoutTableCell()
        }
        
        let exercise = sections[indexPath.section].exercises[indexPath.row]
        cell.titleLabel.text = exercise.exercise?.name
        cell.previewImageView.image = UIImage(named: (exercise.gifName + ".gif"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedExercise = sections[indexPath.section].exercises[indexPath.row]
        delegate?.exerciseSelected(selectedExercise)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oldWorkout" {
            let vc = segue.destination as! NewWorkoutPopupViewController
            let cell = sender as! AddWorkoutTableCell
            let indexPath = self.tableView!.indexPath(for: cell)
            let diaryItem = DiaryItem(e: sections[indexPath!.section].exercises[indexPath!.row].exercise, d: Duration(durationInSeconds: sections[indexPath!.section].exercises[indexPath!.row].durationInSeconds?.durationInSeconds))
            vc.diaryItem = diaryItem
        }
    }


}
