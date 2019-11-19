//
//  GifViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-18.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class GifViewController: UIViewController {

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
    let gifs = ["crunch", "air-bike-crunches"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.gifView.loadGif(name: self.gifs[0])
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
    
    private func refreshUI(){
        loadView()
        
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
    
    func createProgressBar(){
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width/4, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
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
