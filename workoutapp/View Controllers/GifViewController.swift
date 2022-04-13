//
//  GifViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-18.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import AVFoundation

class GifViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var exerciseCounter: UILabel!
    
    @IBOutlet weak var totalProgress: UIProgressView!
    @IBOutlet weak var exerciseTitle: UILabel!
    
    
    // MARK: - Properties
    
    var exercisesDone : [AppExercise] = []
    var player: AVAudioPlayer?
    
    var user: User = User()
    var PB = progressBar()
    var restDuration = 10
    var timer = Timer()
    var exerciseTimer = Timer()
    var isResting = false
    var currentExerciseIndex = 0
    var exerciseSeconds = 0
    var resumeTapped: Bool = false
    var seconds = 0
    var routineDuration = 0
    var routineExercises: [AppExercise] = []
    
    var completedRoutine: dailyRoutine?
    
    
    var section: RoutineSection? {
        didSet {
            refreshUI()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIScene.willDeactivateNotification, object: nil)
    }
    
    // MARK: - Helpers
    
    @objc func appMovedToBackground() {
//        print("App moved to background!")
        pauseRoutine()
    }
    
    private func refreshUI(){
        loadView()
        user = RealmManager.getUser()
        restDuration = user.restDuration
        
        guard let section = section else { return }
        
        let currentExercise = section.exercises[currentExerciseIndex]
        gifView.loadGif(name: currentExercise.gifName)
        exerciseSeconds = (currentExercise.durationInSeconds?.durationInSeconds)!
        exerciseTitle.text = (currentExercise.exercise?.name)!
        
        counter.text = self.timeString(time: TimeInterval(self.seconds))
        exerciseCounter.text = self.timeString(time: TimeInterval(self.exerciseSeconds))
        for _ in 1...Int(section.repetition) {
            routineExercises += section.exercises
        }
        routineDuration = (section.repetition * section.getDuration()) + ((routineExercises.count-1) * restDuration)
        
        if restDuration != 0 || (currentExerciseIndex == (routineExercises.count-1)) {
            nextLabel.text = "Next: Rest"
        } else if currentExerciseIndex < (routineExercises.count - 1) {
            nextLabel.text = "Next: \(String(describing: routineExercises[currentExerciseIndex+1].exercise!.name))"
        }
        
        runTimer()
        totalProgress.progress = 0.0
        PB.create(view: self.view, duration: self.exerciseSeconds)
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let strongSelf = self else { return }
            
            strongSelf.seconds += 1
            strongSelf.totalProgress.progress += (1.0/Float(strongSelf.routineDuration))
            strongSelf.counter.text = strongSelf.timeString(time: TimeInterval(strongSelf.seconds))
            if (strongSelf.seconds == strongSelf.routineDuration/2) {
                strongSelf.playSound(name: "halfway", extensionType: "m4a")
            }
            
            if (strongSelf.seconds == strongSelf.routineDuration) {
                strongSelf.timer.invalidate()
                strongSelf.finishRoutine()
            }
        }
        exerciseTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let strongSelf = self else { return }
            
            if strongSelf.exerciseSeconds != 0 {
                strongSelf.exerciseSeconds -= 1
            }
            
            if strongSelf.exerciseSeconds == 4 {
                if strongSelf.canRest() {
                    strongSelf.playSound(name: "rest in", extensionType: "m4a")
                } else {
                    strongSelf.playSound(name: "start in", extensionType: "m4a")
                }
            } else if strongSelf.exerciseSeconds == 3 {
                strongSelf.playSound(name: "countdown", extensionType: "wav")
            } else if strongSelf.exerciseSeconds < 1 {
                if (strongSelf.currentExerciseIndex < ((strongSelf.routineExercises.count)-1)) {
                    strongSelf.canRest() ? strongSelf.userWillRest() : strongSelf.userWillDoNextExercise()
                } else {
                    strongSelf.exerciseTimer.invalidate()
                }
            }
            strongSelf.exerciseCounter.text = strongSelf.timeString(time: TimeInterval(strongSelf.exerciseSeconds))
        }
    }
    
    func canRest() -> Bool {
        return (!isResting && (restDuration != 0))
    }
    
    func userWillRest() {
        exerciseSeconds = restDuration
         gifView.image = UIImage(named: "rest.png")
         exerciseTitle.text = "Rest"
         nextLabel.text = "Next: \(String(describing: self.routineExercises[self.currentExerciseIndex+1].exercise!.name))"
         isResting = true
         PB.startOver(duration: self.exerciseSeconds)
        
        //after finishing one exercise
        exercisesDone.append(self.routineExercises[self.currentExerciseIndex])
    }
    
    func userWillDoNextExercise() {
        increaseExerciseIndex()
        let currentExercise = routineExercises[currentExerciseIndex]
        exerciseSeconds = (currentExercise.durationInSeconds!.durationInSeconds)
        gifView.loadGif(name: (currentExercise.gifName))
        exerciseTitle.text = currentExercise.exercise?.name
        if (restDuration != 0 || (currentExerciseIndex == ((routineExercises.count)-1))) {
            nextLabel.text = "Next: Rest"
        } else if (currentExerciseIndex < ((routineExercises.count)-1)) {
            nextLabel.text = "Next: \(String(describing: routineExercises[currentExerciseIndex+1].exercise!.name))"
        }
        isResting = false
        PB.startOver(duration: exerciseSeconds)
    }
    
    func increaseExerciseIndex() {
        currentExerciseIndex += 1
    }
    
    func exitRoutine() {
       addExercisesToDiary()
        UIApplication.shared.isIdleTimerDisabled = false
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as? RoutineCollectionViewController {
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func finishRoutine() {
        addExercisesToDiary()
        UIApplication.shared.isIdleTimerDisabled = false
        playSound(name: "good job", extensionType: "m4a")
        performSegue(withIdentifier: "wellDone", sender: Any?.self)
    }
    
    func addExercisesToDiary() {
        if !isResting && (exerciseSeconds == 0) {
            exercisesDone.append(routineExercises[currentExerciseIndex])
        }
        DiaryItem.add(appExList: exercisesDone)
        if !isResting && (exerciseSeconds != 0) {
            let lastExercise = routineExercises[currentExerciseIndex].exercise
            let remainingDuration = Duration(durationInSeconds:  routineExercises[currentExerciseIndex].durationInSeconds!.durationInSeconds - exerciseSeconds)
            DiaryItem(e: lastExercise, d: remainingDuration).add()
        }
        
        completedRoutine = dailyRoutine(exerciseType: section!.title, durationInSeconds: self.seconds)
        completedRoutine?.add()
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func pauseRoutine() {
        timer.invalidate()
        exerciseTimer.invalidate()
        PB.pause()
    }
    
    func resumeRoutine() {
        runTimer()
        PB.resume()
    }
    
    func playSound(name: String, extensionType:String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: extensionType) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)

            guard let player = player else { return }

            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func togglePlay(_ sender: Any) {
        resumeTapped ? resumeRoutine() : pauseRoutine()
        playPause.setBackgroundImage(UIImage(systemName: resumeTapped ? "pause.fill" : "play.fill"), for: .normal)
        resumeTapped = !resumeTapped
    }
    
    @IBAction func quitRoutine(_ sender: Any) {
        pauseRoutine()
        let alert = UIAlertController(title: "Do you want to finish workout?", message: "It will exit this routine and your progress will be lost.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            self?.exitRoutine()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [weak self] action in
            self?.resumeRoutine()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wellDone", let destination = segue.destination as? WorkoutCompleteViewController{
            destination.completedRoutine = completedRoutine
            destination.exercisesCount = currentExerciseIndex + 1
            destination.durationInSeconds = seconds
            
        }
    }
}
