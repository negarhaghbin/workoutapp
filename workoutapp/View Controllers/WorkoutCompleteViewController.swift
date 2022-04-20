//
//  WorkoutCompleteViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-06-22.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class WorkoutCompleteViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var numberOfExercises: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var balloon: Balloon!
    @IBOutlet weak var didNotEnjoyButton: UIButton!
    @IBOutlet weak var enjoyButton: UIButton!
    @IBOutlet weak var nuetralButton: UIButton!
    
    // MARK: - Properties
    
    var exercisesCount = 0
    var durationInSeconds = 0
    
    var completedRoutine: DailyRoutine?
    var feeling = ""
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showCongratulationAnimation(balloon: balloon)
        numberOfExercises.text = String(exercisesCount)
        minutesLabel.text = String(format: "%.1f", secondsToMinutes(seconds:  durationInSeconds))
    }
    
    // MARK: - Actions
    
    @IBAction func didNotEnjoyed(_ sender: Any) {
        didNotEnjoyButton.backgroundColor = ColorPalette.mainPink
        enjoyButton.backgroundColor = UIColor.black
        nuetralButton.backgroundColor = UIColor.black
        feeling = RoutineFeeling.bad.rawValue
    }
    
    @IBAction func feltNeutral(_ sender: Any) {
        nuetralButton.backgroundColor = ColorPalette.mainPink
        enjoyButton.backgroundColor = UIColor.black
        didNotEnjoyButton.backgroundColor = UIColor.black
        feeling = RoutineFeeling.neutral.rawValue
    }
    
    @IBAction func enjoyed(_ sender: Any) {
        enjoyButton.backgroundColor = ColorPalette.mainPink
        didNotEnjoyButton.backgroundColor = UIColor.black
        nuetralButton.backgroundColor = UIColor.black
        feeling = RoutineFeeling.good.rawValue
    }
    
    @IBAction func done(_ sender: Any) {
        completedRoutine?.setFeeling(feeling: feeling)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as? RoutineCollectionViewController {
            let viewcontrollers = [vc]
            navigationController?.setViewControllers(viewcontrollers, animated: true)
        }
    }
}
