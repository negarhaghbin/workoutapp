//
//  progressBar.swift
//  workoutapp
//
//  Created by Negar on 2019-12-29.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class progressBar: NSObject {
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    func create(view: UIView, duration: Int){
        let center = CGPoint(x:view.center.x, y:view.center.y*15/14)
        var radius = CGFloat(0)
        let width = view.frame.width
        let height = view.frame.height
        if (  width > height){
            radius = height/4
        }
        else{
            radius = width/4
        }
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.systemGray6.cgColor
        trackLayer.lineWidth = 10
        trackLayer.name = "track"
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.name = "stroke"
        shapeLayer.strokeColor = UIColor.systemPink.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.toValue = 1
        basicAnimation.duration = Double(duration)
        basicAnimation.isRemovedOnCompletion = true
        
        shapeLayer.add(basicAnimation,forKey: "timer")
    }
    
    func startOver(duration: Int){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.toValue = 1
        basicAnimation.duration = Double(duration)
        basicAnimation.isRemovedOnCompletion = true
        
        shapeLayer.add(basicAnimation,forKey: "timer")
    }
    
    func changeColor(view: UIView, color:UIColor){
        for layer in view.layer.sublayers! {
            if layer.name == "stroke" {
                 layer.removeFromSuperlayer()
            }
        }
        shapeLayer.strokeColor = color.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    func changeEndAngle(view: UIView, percentage: Double){
        for layer in view.layer.sublayers! {
            if layer.name == "stroke" {
                 layer.removeFromSuperlayer()
            }
        }
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width/4, startAngle: -CGFloat.pi/2, endAngle: (CGFloat(percentage/100)*2*CGFloat.pi)-CGFloat.pi/2, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        view.layer.addSublayer(shapeLayer)
    }
    
    func changeView(oldView: UIView, newView: UIView){
        for layer in oldView.layer.sublayers! {
            if layer.name == "track" {
                 layer.removeFromSuperlayer()
            }
        }
        let center = newView.center
        let circularPath = UIBezierPath(arcCenter: center, radius: newView.frame.width/4, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        trackLayer.path = circularPath.cgPath
        newView.layer.addSublayer(trackLayer)
        
        
        for layer in oldView.layer.sublayers! {
            if layer.name == "stroke" {
                 layer.removeFromSuperlayer()
            }
        }
        shapeLayer.path = circularPath.cgPath
        newView.layer.addSublayer(shapeLayer)
    }
        
     func pause(){
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
          shapeLayer.speed = 0.0
          shapeLayer.timeOffset = pausedTime
    }

    func resume(){
          let pausedTime = shapeLayer.timeOffset
          shapeLayer.speed = 1.0
          shapeLayer.timeOffset = 0.0
          shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
}
