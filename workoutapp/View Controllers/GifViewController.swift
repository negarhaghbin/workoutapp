//
//  GifViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-18.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class GifViewController: UIViewController {

    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var exerciseCounter: UILabel!
    
    @IBOutlet weak var totalProgress: UIProgressView!
    @IBOutlet weak var exerciseTitle: UILabel!
    
    var exercisesDone : [AppExercise] = []
    
    
    var player: AVAudioPlayer?
    
    var user : User = User()
    var PB = progressBar()
    var restDuration = 10
    var timer = Timer()
    var exerciseTimer = Timer()
    var isResting = false
    var currentExerciseIndex = 0
    var exerciseSeconds = 0
    var resumeTapped : Bool = false
    var seconds = 0
    var routineDuration = 0
    var routineExercises :[AppExercise] = []
    
    
    var section : RoutineSection?{
        didSet{
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = try! Realm().object(ofType: User.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))!
        restDuration = user.restDuration
        routineDuration = (section!.repetition * (section?.getDuration())!) + ((routineExercises.count-1) * restDuration)
    }
    
    private func refreshUI(){
        loadView()
        
        gifView.loadGif(name: (section?.exercises[0].gifName)!)
        exerciseSeconds = (section?.exercises[0].durationInSeconds?.durationInSeconds)!
        exerciseTitle.text = (section?.exercises[0].exercise?.name)!
        nextLabel.text = "Next: Rest"
        counter.text = self.timeString(time: TimeInterval(self.seconds))
        exerciseCounter.text = self.timeString(time: TimeInterval(self.exerciseSeconds))
        for _ in 1...Int(section!.repetition){
            routineExercises += section!.exercises
        }
        routineDuration = (section!.repetition * (section?.getDuration())!) + ((routineExercises.count-1) * restDuration)
        
        runTimer()
        totalProgress.progress = 0.0
        totalProgress.transform = totalProgress.transform.scaledBy(x: 1, y: 10)
        PB.create(view: self.view, duration: self.exerciseSeconds)
        
    }
    
    func runTimer(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds += 1
            self.totalProgress.progress += (1.0/Float(self.routineDuration))
            self.counter.text = self.timeString(time: TimeInterval(self.seconds))
            if (self.seconds == self.routineDuration/2){
                self.playSound(name: "halfway", extensionType: "m4a")
            }
            if (self.seconds == self.routineDuration){
                self.timer.invalidate()
                self.finishRoutine()
            }
        }
        exerciseTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.exerciseSeconds -= 1
            if self.exerciseSeconds == 4{
                if (!self.isResting){
                    self.playSound(name: "rest in", extensionType: "m4a")
                }
                else{
                    self.playSound(name: "start in", extensionType: "m4a")
                }
            }
            else if self.exerciseSeconds == 3{
                self.playSound(name: "countdown", extensionType: "wav")
            }
            else if self.exerciseSeconds == 0 {
                if (self.currentExerciseIndex < ((self.routineExercises.count)-1)){
                    if (!self.isResting){
                        self.exerciseSeconds = self.restDuration
                        self.gifView.image=UIImage(named: "rest.png")
                        self.exerciseTitle.text = "Rest"
                        self.nextLabel.text = "Next: \(String(describing: self.routineExercises[self.currentExerciseIndex+1].exercise!.name))"
                        self.isResting = true
                        self.PB.startOver(duration: self.exerciseSeconds)
                       //after finishing one exercise
                       self.exercisesDone.append(self.routineExercises[self.currentExerciseIndex])
                    }
                    else{
                        self.increaseExerciseIndex()
                        self.exerciseSeconds = (self.routineExercises[self.currentExerciseIndex].durationInSeconds!.durationInSeconds)
                        self.gifView.loadGif(name: (self.routineExercises[self.currentExerciseIndex].gifName))
                        self.exerciseTitle.text = self.routineExercises[self.currentExerciseIndex].exercise?.name
                        self.nextLabel.text = "Next: Rest"
                        self.isResting = false
                        self.PB.startOver(duration: self.exerciseSeconds)
                    }
                }
                else{
                    self.exerciseTimer.invalidate()
                }
                
            }
            self.exerciseCounter.text = self.timeString(time: TimeInterval(self.exerciseSeconds))

        }
    }
    
    func increaseExerciseIndex(){
        currentExerciseIndex += 1
    }
    
    func exitRoutine(){
       addExercisesToDiary()
        UIApplication.shared.isIdleTimerDisabled = false
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! RoutineCollectionViewController
        let viewcontrollers = [vc]
        self.navigationController!.setViewControllers(viewcontrollers, animated: true)
    }
    
    func finishRoutine(){
        addExercisesToDiary()
        UIApplication.shared.isIdleTimerDisabled = false
        playSound(name: "good job", extensionType: "m4a")
        self.performSegue(withIdentifier: "wellDone", sender:Any?.self)
    }
    
    func addExercisesToDiary(){
        if (!isResting && exerciseSeconds == 0){
            exercisesDone.append(self.routineExercises[self.currentExerciseIndex])
        }
        DiaryItem.add(appExList: exercisesDone)
        if (!isResting && exerciseSeconds != 0){
            let lastExercise = self.routineExercises[self.currentExerciseIndex].exercise
            let remainingDuration = Duration(durationInSeconds:  self.routineExercises[self.currentExerciseIndex].durationInSeconds!.durationInSeconds - exerciseSeconds)
            DiaryItem(e: lastExercise, d: remainingDuration).add()
        }
        dailyRoutine.add(seconds: self.seconds, sectionTitle: section!.title)
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func pauseRoutine(){
        timer.invalidate()
        exerciseTimer.invalidate()
        PB.pause()
    }
    
    func resumeRoutine(){
        runTimer()
        PB.resume()
    }
    
    @IBAction func togglePlay(_ sender: Any) {
        if self.resumeTapped == false {
            pauseRoutine()
            self.resumeTapped = true
            self.playPause.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            resumeRoutine()
            self.resumeTapped = false
            self.playPause.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func quitRoutine(_ sender: Any) {
        pauseRoutine()
        let alert = UIAlertController(title: "Do you want to finish workout?", message: "It will exit this routine and your progress will be lost.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            self.exitRoutine()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {
            action in
            self.resumeRoutine()
        }))
        self.present(alert, animated: true)
    }
    
    func playSound(name: String, extensionType:String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: extensionType) else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wellDone", let destination = segue.destination as? WorkoutCompleteViewController{
            destination.exercisesCount = currentExerciseIndex+1
            destination.durationInSeconds = seconds
            
        }
    }
}
