//
//  SettingsViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-09.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    var setting : Setting?{
        didSet{
            refreshUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func refreshUI(){
        loadView()
        titleLabel.text=setting?.title
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

extension SettingsViewController: SettingsSelectionDelegate {
  func settingSelected(_ newSetting: Setting) {
    setting=newSetting
  }
}
