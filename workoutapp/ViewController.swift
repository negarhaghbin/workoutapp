//
//  ViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var video : Video = Video.init(url: URL(fileURLWithPath: "") , thumbURL: URL(fileURLWithPath: ""), title: "", subtitle: "", steps: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text=video.title
        subtitleView.text=video.subtitle
        previewImageView.image=UIImage(named: (video.thumbURL.path))
        for (index,step) in video.steps.enumerated(){
            let stepView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            stepView.center = CGPoint(x: 160, y: 285+index*20)
            stepView.textAlignment = .center
            stepView.text=step.1
            self.view.addSubview(stepView)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        let videoURL = video.url
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        present(playerViewController, animated: true) {
            player.play()
        }
    }
}

