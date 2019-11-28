//
//  ViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import YouTubePlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let StepCellReuseIdentifier = "StepTableViewCell"
    
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var youtubeView: YouTubePlayerView!
    var exercise : ExerciseModel?{
        didSet{
            refreshUI()
        }
    }
    
    private func refreshUI(){
        loadView()
        if (exercise?.videoURLString != ""){
            youtubeView.loadVideoURL(URL(string: exercise!.videoURLString)!)
        }
        titleLabel.text = exercise?.title
        subtitleView.text=exercise?.getDescription()
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        guard let cell = tableView.dequeueReusableCell(withIdentifier: StepCellReuseIdentifier, for: indexPath) as? StepTableViewCell else {
//            return StepTableViewCell()
//        }
//        let step = video?.steps[indexPath.row]
//        cell.numberLabel.text = String(step!.0)
//        cell.descriptionLabel.text = step!.1
//
//        return cell
        return StepTableViewCell()
    }
}

extension ViewController: ExerciseSelectionDelegate {
  func exerciseSelected(_ newExercise: ExerciseModel) {
    exercise = newExercise
  }
}

