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
    
    var nextViewControllerTabIndex: Int = 0
    var wasUseful: Bool = false
    var interaction: Interaction = Interaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func like(_ sender: Any) {
        likeButton.backgroundColor = ColorPalette.mainPink
        dislikeButton.backgroundColor = UIColor.black
        wasUseful = true
        doneButton.isEnabled = true
        doneButton.backgroundColor = ColorPalette.mainPink
    }
    @IBAction func dislike(_ sender: Any) {
        dislikeButton.backgroundColor = ColorPalette.mainPink
        likeButton.backgroundColor = UIColor.black
        wasUseful = false
        doneButton.isEnabled = true
        doneButton.backgroundColor = ColorPalette.mainPink
    }
    
    @IBAction func exit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabbarController = storyboard.instantiateViewController(withIdentifier: "TabBarVCStoryboard") as? TabBarViewController {
            tabbarController.selectedIndex = nextViewControllerTabIndex
            UIApplication.shared.windows.first?.rootViewController = tabbarController
        }
    }
    
    @IBAction func done(_ sender: Any) {
        interaction.setWasUseful(wasUseful: wasUseful)
        exit(self)
    }
}
