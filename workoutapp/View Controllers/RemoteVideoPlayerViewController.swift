//
//  RemoteVideoPlayerViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-18.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import YouTubePlayer

class RemoteVideoPlayerViewController: UIViewController {

    @IBOutlet weak var youtubeView: YouTubePlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoUrl = URL(string: "https://youtu.be/MKmrqcoCZ-M")
        youtubeView.loadVideoURL(videoUrl!)
        // Do any additional setup after loading the view.
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
