//
//  NotificationLauncherViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-06-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class NotificationLauncherViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var nextViewControllerTabIndex : Int = 0
    var wasUseful : Bool = false
    var interaction : Interaction = Interaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func like(_ sender: Any) {
        likeButton.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.31, blue: 0.67, alpha: 1.0)
        dislikeButton.backgroundColor = UIColor.black
        wasUseful = true
        doneButton.isEnabled = true
        doneButton.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.31, blue: 0.67, alpha: 1.0)
    }
    @IBAction func dislike(_ sender: Any) {
        dislikeButton.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.31, blue: 0.67, alpha: 1.0)
        likeButton.backgroundColor = UIColor.black
        wasUseful = false
        doneButton.isEnabled = true
        doneButton.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.31, blue: 0.67, alpha: 1.0)
    }
    
    @IBAction func exit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarController = storyboard.instantiateViewController(withIdentifier: "TabBarVCStoryboard") as! TabBarViewController
        tabbarController.selectedIndex = nextViewControllerTabIndex
        UIApplication.shared.windows.first?.rootViewController = tabbarController
    }
    
    @IBAction func done(_ sender: Any) {
        interaction.setWasUseful(wasUseful: wasUseful)
        exit(self)
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
