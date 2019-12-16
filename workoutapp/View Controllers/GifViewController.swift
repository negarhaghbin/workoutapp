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

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var exerciseCounter: UILabel!
    
    @IBOutlet weak var exerciseTitle: UILabel!
    var animationTimer: Timer?
    var startTime: TimeInterval?, endTime: TimeInterval?
    let animationDuration = 3.0
    var height: CGFloat = 0
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var balloon: Balloon!
    
    let shapeLayer = CAShapeLayer()
    let restDuration = 10
    var timer = Timer()
    var exerciseTimer = Timer()
    var isResting = false
    var currentExerciseIndex = 0
    var exerciseSeconds = 0
    var resumeTapped : Bool = false
    var seconds = 0
    var routineDuration = 0
    var section : RoutineSection?{
        didSet{
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func refreshUI(){
        loadView()
        gifView.loadGif(name: (section?.exercises[0].gifName)!)
        exerciseSeconds = (section?.exercises[0].durationS)!
        exerciseTitle.text = (section?.exercises[0].title)!
        routineDuration = (self.section?.getDuration())! + ((section?.exercises.count)!-1) * restDuration
        runTimer()
        createProgressBar()
        
    }
    
    func runTimer(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds += 1
            self.counter.text = self.timeString(time: TimeInterval(self.seconds))
            if (self.seconds == self.routineDuration/2){
                self.playSound(name: "halfway")
            }
            if (self.seconds == self.routineDuration){
                self.timer.invalidate()
                self.finishRoutine()
            }
        }
        exerciseTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.exerciseSeconds -= 1
            self.exerciseCounter.text = self.timeString(time: TimeInterval(self.exerciseSeconds))
            if self.exerciseSeconds == 1 {
                if (self.currentExerciseIndex < ((self.section?.exercises.count)!-1)){
                    if (!self.isResting){
                        self.exerciseSeconds = self.restDuration
                        self.gifView.image=UIImage(named: "rest.png")
                        self.exerciseTitle.text = "Rest"
                        self.isResting = true
                    }
                    else{
                        self.increaseExerciseIndex()
                        self.exerciseSeconds = (self.section?.exercises[self.currentExerciseIndex].durationS)!
                        self.gifView.loadGif(name: (self.section?.exercises[self.currentExerciseIndex].gifName)!)
                        self.exerciseTitle.text = self.section?.exercises[self.currentExerciseIndex].title
                        self.isResting = false
                    }
                }
                else{
                    //self.finishRoutine()
                    self.exerciseTimer.invalidate()
                }
                
            }

        }
    }
    
    func increaseExerciseIndex(){
        currentExerciseIndex += 1
    }
    
    func exitRoutine(){
        dailyRoutine.update(seconds: self.seconds)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! RoutineCollectionViewController
        let viewcontrollers = [vc]
        self.navigationController!.setViewControllers(viewcontrollers, animated: true)
    }
    
    func finishRoutine(){
        let alert = UIAlertController(title: "Well done!", message: "You have succesfully finished your today's workout.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {
            action in
            self.exitRoutine()
        }))
        showCongratulationAnimation()
        playSound(name: "good job")
        self.present(alert, animated: true)
        
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func pauseRoutine(){
        timer.invalidate()
        exerciseTimer.invalidate()
        pauseAnimation()
    }
    
    func resumeRoutine(){
        runTimer()
        resumeAnimation()
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
    
    func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "m4a") else { return }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GifViewController{
    
    func createProgressBar(){
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width/4, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemPink.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.toValue = 1
        basicAnimation.duration = Double(routineDuration)
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation,forKey: "timer")
    }
    
     func pauseAnimation(){
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
          shapeLayer.speed = 0.0
          shapeLayer.timeOffset = pausedTime
    }

    func resumeAnimation(){
          let pausedTime = shapeLayer.timeOffset
          shapeLayer.speed = 1.0
          shapeLayer.timeOffset = 0.0
          shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
          shapeLayer.beginTime = timeSincePause
    }
    
}

extension GifViewController{
    func showCongratulationAnimation() {
        height = UIScreen.main.bounds.height + balloon.frame.size.height
        balloon.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: height + balloon.frame.size.height / 2)
        balloon.isHidden = false
        startTime = Date().timeIntervalSince1970
        endTime = animationDuration + startTime!
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { timer in
            self.updateAnimation()
        }
    }
    
    func updateAnimation() {
        guard
            let endTime = endTime,
            let startTime = startTime
            else {
              return
          }
          let now = Date().timeIntervalSince1970

          
          if now >= endTime {
            animationTimer?.invalidate()
            balloon.isHidden = true
          }

          
          let percentage = (now - startTime) * 100 / animationDuration
          let y = height - ((height + balloon.frame.height / 2) / 100 *
            CGFloat(percentage))

          
          balloon.center = CGPoint(x: balloon.center.x +
            CGFloat.random(in: -0.5...0.5), y: y)
    }
}
