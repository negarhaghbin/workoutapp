//
//  StartRoutineViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-16.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class StartRoutineViewController: UIViewController {
    @IBOutlet weak var counter: UILabel!
    var section : RoutineSection?
    var timer = Timer()
    var seconds = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
        

        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds -= 1
            self.counter.text = "\(self.seconds)"

            if self.seconds == 0 {
                timer.invalidate()
                self.counter.text = "Start"
                self.performSegue(withIdentifier: "start", sender: self)
//                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! GifViewController
//                self.show(myVC, sender: Any?.self)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        let vc = segue.destination as? GifViewController
        // Pass the selected object to the new view controller.
        vc!.section = section
    }
    

}
