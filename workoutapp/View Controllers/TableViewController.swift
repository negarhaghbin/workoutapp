//
//  TableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

protocol ExerciseSelectionDelegate: AnyObject {
  func exerciseSelected(_ newExercise: AppExercise)
}

class TableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var sections : [RoutineSection] = RoutineSection.getRoutineSections()
    let VideoTableViewCellIdentifier = "VideoTableViewCell"
    
    weak var delegate: ExerciseSelectionDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].exercises.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCellIdentifier, for: indexPath) as? VideoTableViewCell else { return VideoTableViewCell() }
        
        let exercise = sections[indexPath.section].exercises[indexPath.row]
        cell.titleLabel.text = exercise.exercise?.name
        cell.previewImageView.image = UIImage(named: (exercise.gifName + ".gif"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedExercise = sections[indexPath.section].exercises[indexPath.row]
        delegate?.exerciseSelected(selectedExercise)
        if let detailViewController = delegate as? ViewController, let detailNavigationController = detailViewController.navigationController {
          splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
}
