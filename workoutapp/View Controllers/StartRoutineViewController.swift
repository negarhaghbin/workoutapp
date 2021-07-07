//
//  StartRoutineViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-16.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import AVFoundation

class StartRoutineViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var counter: UILabel!
    
    // MARK: - Variables
    var section : RoutineSection?
    var timer = Timer()
    var seconds = 3
    var player: AVAudioPlayer?
    
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
        self.counter.text = "\(seconds)"
        self.playSound()
        

        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds -= 1
            if self.seconds > 0 {
                self.counter.text = "\(self.seconds)"
                self.playSound()
            }
            
            if self.seconds == 0 {
                self.counter.text = "Start"
                self.playSound()
            }
            if self.seconds == -1 {
                timer.invalidate()
                self.performSegue(withIdentifier: "start", sender: self)
            }
        }
    }
    

    // MARK: - Helpers
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? GifViewController
    
        vc!.section = section
    }
    

}
