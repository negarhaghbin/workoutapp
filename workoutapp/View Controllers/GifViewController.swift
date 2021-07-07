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
    
    var completedRoutine : dailyRoutine?
    
    
    var section : RoutineSection?{
        didSet{
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIScene.willDeactivateNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        pauseRoutine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func refreshUI(){
        loadView()
        user = RealmManager.getUser()
        restDuration = user.restDuration
        
        let currentExercise = section?.exercises[currentExerciseIndex]
        gifView.loadGif(name: (currentExercise?.gifName)!)
        exerciseSeconds = (currentExercise!.durationInSeconds?.durationInSeconds)!
        exerciseTitle.text = (currentExercise!.exercise?.name)!
        
        counter.text = self.timeString(time: TimeInterval(self.seconds))
        exerciseCounter.text = self.timeString(time: TimeInterval(self.exerciseSeconds))
        for _ in 1...Int(section!.repetition){
            routineExercises += section!.exercises
        }
        routineDuration = (section!.repetition * (section?.getDuration())!) + ((routineExercises.count-1) * restDuration)
        
        if (restDuration != 0 || (currentExerciseIndex == ((routineExercises.count)-1))){
            nextLabel.text = "Next: Rest"
        }
        else if (currentExerciseIndex < ((routineExercises.count)-1)){
            print(routineExercises)
            nextLabel.text = "Next: \(String(describing: routineExercises[currentExerciseIndex+1].exercise!.name))"
        }
        
        runTimer()
        totalProgress.progress = 0.0
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
            if self.exerciseSeconds != 0{
                self.exerciseSeconds -= 1
            }
            if self.exerciseSeconds == 4{
                if self.canRest(){
                    self.playSound(name: "rest in", extensionType: "m4a")
                }
                else{
                    self.playSound(name: "start in", extensionType: "m4a")
                }
            }
            else if self.exerciseSeconds == 3{
                self.playSound(name: "countdown", extensionType: "wav")
            }
            else if self.exerciseSeconds < 1 {
                if (self.currentExerciseIndex < ((self.routineExercises.count)-1)){
                    if (self.canRest()){
                        self.userWillRest()
                    }
                    else{
                        self.userWillDoNextExercise()
                    }
                }
                else{
                    self.exerciseTimer.invalidate()
                }
                
            }
            self.exerciseCounter.text = self.timeString(time: TimeInterval(self.exerciseSeconds))

        }
    }
    
    func canRest()->Bool{
        return (!isResting && (restDuration != 0))
    }
    
    func userWillRest(){
        exerciseSeconds = restDuration
         gifView.image=UIImage(named: "rest.png")
         exerciseTitle.text = "Rest"
         nextLabel.text = "Next: \(String(describing: self.routineExercises[self.currentExerciseIndex+1].exercise!.name))"
         isResting = true
         PB.startOver(duration: self.exerciseSeconds)
        //after finishing one exercise
        exercisesDone.append(self.routineExercises[self.currentExerciseIndex])
    }
    
    func userWillDoNextExercise(){
        increaseExerciseIndex()
        let currentExercise = routineExercises[currentExerciseIndex]
        exerciseSeconds = (currentExercise.durationInSeconds!.durationInSeconds)
        gifView.loadGif(name: (currentExercise.gifName))
        exerciseTitle.text = currentExercise.exercise?.name
        if (restDuration != 0 || (currentExerciseIndex == ((routineExercises.count)-1))){
            nextLabel.text = "Next: Rest"
        }
        else if (currentExerciseIndex < ((routineExercises.count)-1)){
            nextLabel.text = "Next: \(String(describing: routineExercises[currentExerciseIndex+1].exercise!.name))"
        }
        isResting = false
        PB.startOver(duration: exerciseSeconds)
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
        
        completedRoutine = dailyRoutine(exerciseType: section!.title, durationInSeconds: self.seconds)
        completedRoutine!.add()
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
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
//            let utterance = AVSpeechUtterance(string: "Good job")
//            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.Victoria")
//            utterance.rate = 0.4
//
//            let synthesizer = AVSpeechSynthesizer()
//            synthesizer.speak(utterance)

            
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
            destination.completedRoutine = completedRoutine
            destination.exercisesCount = currentExerciseIndex+1
            destination.durationInSeconds = seconds
            
        }
    }
}
