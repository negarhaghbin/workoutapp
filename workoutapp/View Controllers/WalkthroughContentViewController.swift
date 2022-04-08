//
//  WalkthroughContentViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-08-13.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subheadingLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var viewWithImage: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Properties
    
    var index = 0
    var onboardingPage: OnboardingPage?
    let dateFormatter = DateFormatter()
    var datePickerValue = ""
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "HH:mm"
        datePickerValue = dateFormatter.string(from: Date())
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let onboardingPage = onboardingPage {
            headingLabel.text = onboardingPage.title
            subheadingLabel.text = onboardingPage.subtitle
            contentImageView.image = UIImage(named: onboardingPage.imageName)
        }
        
        datePicker.isHidden = true
        contentImageView.isHidden = true
        nameTextField.isHidden = true
        subheadingLabel.isHidden = false
        
        switch index {
        case 0..<WalkthroughViewController.PageIndex.setName.rawValue:
            contentImageView.isHidden = false
        case WalkthroughViewController.PageIndex.setName.rawValue:
            subheadingLabel.isHidden = true
            contentImageView.isHidden = false
            nameTextField.isHidden = false
        case WalkthroughViewController.PageIndex.timeBasedReminder.rawValue:
            contentImageView.isHidden = true
            datePicker.isHidden = false
            datePicker.datePickerMode = .time
        case WalkthroughViewController.PageIndex.locationBasedReminder.rawValue:
            contentImageView.isHidden = true
            datePicker.isHidden = false
            datePicker.datePickerMode = .countDownTimer
        default:
            contentImageView.isHidden = false
            break
        }
    }

    
    // MARK: - Helpers
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        switch index {
        case WalkthroughViewController.PageIndex.timeBasedReminder.rawValue:
            datePicker.date = sender.date
            datePickerValue = dateFormatter.string(from: sender.date)
            
        case WalkthroughViewController.PageIndex.locationBasedReminder.rawValue:
            datePicker.countDownDuration = sender.countDownDuration
            datePickerValue = MinutesToString(time: Int(sender.countDownDuration))
            
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate

extension WalkthroughContentViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let trimmedName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            NotificationCenter.default.post(name: NotificationNames.nameFieldChanged, object: nil, userInfo: ["name": trimmedName])
        }
    }
}
