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
    
    var section: RoutineSection?
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
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let strongSelf = self else {return}
            
            strongSelf.seconds -= 1
            if strongSelf.seconds > 0 {
                strongSelf.counter.text = "\(strongSelf.seconds)"
                strongSelf.playSound()
            }
            
            if strongSelf.seconds == 0 {
                strongSelf.counter.text = "Start"
                strongSelf.playSound()
            }
            if strongSelf.seconds == -1 {
                timer.invalidate()
                strongSelf.performSegue(withIdentifier: SegueIdentifiers.start, sender: self)
            }
        }
    }
    

    // MARK: - Helpers
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GifViewController {
            vc.section = section
        }
    }
}
