//
//  WorkoutCompleteViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-06-22.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class WorkoutCompleteViewController: UIViewController {

    @IBOutlet weak var numberOfExercises: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var balloon: Balloon!
    
    var exercisesCount = 0
    var durationInSeconds = 0
    
    @IBOutlet weak var didNotEnjoyButton: UIButton!
    @IBOutlet weak var enjoyButton: UIButton!
    @IBOutlet weak var nuetralButton: UIButton!
    
    var completedRoutine : dailyRoutine?
    var feeling = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showCongratulationAnimation(balloon: balloon)
        numberOfExercises.text = String(exercisesCount)
        minutesLabel.text = String(format: "%.1f", secondsToMinutes(seconds:  durationInSeconds))
    }
    
    @IBAction func didNotEnjoyed(_ sender: Any) {
        didNotEnjoyButton.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.31, blue: 0.67, alpha: 1.0)
        enjoyButton.backgroundColor = UIColor.black
        nuetralButton.backgroundColor = UIColor.black
        feeling = RoutineFeeling.bad.rawValue
    }
    @IBAction func feltNeutral(_ sender: Any) {
        nuetralButton.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.31, blue: 0.67, alpha: 1.0)
        enjoyButton.backgroundColor = UIColor.black
        didNotEnjoyButton.backgroundColor = UIColor.black
        feeling = RoutineFeeling.neutral.rawValue
    }
    @IBAction func enjoyed(_ sender: Any) {
        enjoyButton.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.31, blue: 0.67, alpha: 1.0)
        didNotEnjoyButton.backgroundColor = UIColor.black
        nuetralButton.backgroundColor = UIColor.black
        feeling = RoutineFeeling.good.rawValue
    }
    
    @IBAction func done(_ sender: Any) {
        completedRoutine?.setFeeling(feeling: feeling)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! RoutineCollectionViewController
        let viewcontrollers = [vc]
        self.navigationController!.setViewControllers(viewcontrollers, animated: true)
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
