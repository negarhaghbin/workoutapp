//
//  WalkthroughContentViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-08-13.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subheadingLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var viewWithImage: UIView!
    @IBOutlet weak var textField: UITextField!
    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    let SET_NAME_INDEX = 3
    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        subheadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch index {
        case 0...SET_NAME_INDEX-1:
            subheadingLabel.isHidden = false
            viewWithImage.isHidden = false
            textField.isHidden = true
        case SET_NAME_INDEX:
            subheadingLabel.isHidden = true
//            viewWitrhImage.isHidden = true
            textField.isHidden = false
        default:
            break
        }
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
