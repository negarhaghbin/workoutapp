//
//  GifViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-18.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class GifViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var playPause: UIButton!
    let shapeLayer = CAShapeLayer()
    var timer = Timer()
    var resumeTapped : Bool = false
    var seconds = 0
    var section : RoutineSection?{
        didSet{
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func refreshUI(){
        loadView()
        self.gifView.loadGif(name: (section?.exercises[0].gifName)!)
        runTimer()
        createProgressBar()
        
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds += 1
            self.counter.text = self.timeString(time: TimeInterval(self.seconds))
            if self.seconds == 60{
                // self.rest() for 20 seconds
            }

        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @IBAction func togglePlay(_ sender: Any) {
        if self.resumeTapped == false {
             timer.invalidate()
             self.resumeTapped = true
            pauseAnimation()
             self.playPause.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
             runTimer()
             self.resumeTapped = false
            resumeAnimation()
             self.playPause.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func quitRoutine(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to finish workout?", message: "It will exit this routine and your progress will be lost.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! RoutineCollectionViewController
            self.show(myVC, sender: Any?.self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
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
        basicAnimation.duration = 360
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation,forKey: "urSoBasic")
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
