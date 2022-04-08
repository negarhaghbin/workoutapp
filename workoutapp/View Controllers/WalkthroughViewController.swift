//
//  WalkthroughViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-08-13.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Properties
    
    var walkthroughPageViewController : WalkthroughPageViewController?
    var appSettings : notificationSettings = notificationSettings()
    var selectedName: String?
    
    enum PageIndex: Int {
        case dailyReminder = 0
        case diary
        case badge
        case setName
        case timeBasedReminder
        case locationBasedReminder
    }
     
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(nameFieldChanged(notification:)), name: NotificationNames.nameFieldChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dismissKey()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0..<PageIndex.setName.rawValue:
                for _ in index..<PageIndex.setName.rawValue {
                    walkthroughPageViewController?.forwardPage()
                }
                
            case PageIndex.setName.rawValue:
                walkthroughPageViewController?.forwardPage()
            
            case PageIndex.timeBasedReminder.rawValue:
                walkthroughPageViewController?.forwardPage()
                
            case PageIndex.locationBasedReminder.rawValue:
                walkthroughPageViewController?.forwardPage()
                
            default:
                dismiss(animated: true)
            }
        }
        updateUI()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0..<PageIndex.setName.rawValue:
                walkthroughPageViewController?.forwardPage()
                
            case PageIndex.setName.rawValue:
                saveName()
                walkthroughPageViewController?.forwardPage()
            
            case PageIndex.timeBasedReminder.rawValue:
                updateSendOn()
                walkthroughPageViewController?.forwardPage()
                
            case PageIndex.locationBasedReminder.rawValue:
                updateSendAfter()
                walkthroughPageViewController?.forwardPage()
                
            default:
                dismiss(animated: true)
            }
        }
        updateUI()
    }
    
    // MARK: - Helpers
    
    @objc func nameFieldChanged(notification: NSNotification) {
        if let name = notification.userInfo?["name"] as? String {
            selectedName = name
            updateNextButton(isEnabled: !name.isEmpty)
        }
    }
    
    func updateNextButton(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
        nextButton.backgroundColor = isEnabled ? ColorPalette.mainPink : UIColor.systemGray3
    }
    
    private func updateDefaultPageUI() {
        nextButton.setTitle("NEXT", for: .normal)
        updateNextButton(isEnabled: true)
        skipButton.isHidden = false
    }
    
    private func updateSetNameUI() {
        nextButton.setTitle("SAVE", for: .normal)
        updateNextButton(isEnabled: false)
        skipButton.isHidden = false
    }
    
    private func updateTimeBasedNotificationUI() {
        nextButton.setTitle("SAVE", for: .normal)
        updateNextButton(isEnabled: true)
        skipButton.isHidden = false
    }
    
    private func updateLocationBasedReminderUI() {
        nextButton.setTitle("SAVE", for: .normal)
        updateNextButton(isEnabled: true)
        skipButton.isHidden = false
    }
    
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0..<PageIndex.setName.rawValue:
                updateDefaultPageUI()
            
            case PageIndex.setName.rawValue:
                updateSetNameUI()
            
            case PageIndex.timeBasedReminder.rawValue:
                updateTimeBasedNotificationUI()
            
            case PageIndex.locationBasedReminder.rawValue:
                updateLocationBasedReminderUI()
            
            default:
                nextButton.setTitle("GET STARTED", for: .normal)
                updateNextButton(isEnabled: true)
                skipButton.isHidden = true
            }
            pageControl.currentPage = index
        }
    }
    
    
    func saveName() {
        guard let uuid = UserDefaults.standard.string(forKey: "uuid") else { return }
        
        let specificPerson = User.getUser(uuid: uuid)
        if let name = selectedName {
            specificPerson.changeName(newName: name)
        }
    }
    
    func updateSendOn() {
        if let index = walkthroughPageViewController?.currentIndex, let contentVC = walkthroughPageViewController?.contentViewController(at: index) {
            appSettings = notificationSettings.getSettings()
            appSettings.setTime(value: contentVC.datePickerValue)
            appSettings.setUpTimeNotification()
        }
    }
    
    func updateSendAfter() {
        if let index = walkthroughPageViewController?.currentIndex, let contentVC = walkthroughPageViewController?.contentViewController(at: index) {
            appSettings = notificationSettings.getSettings()
            appSettings.setSendAfter(value: Int(contentVC.datePicker.countDownDuration))
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController{
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }

}

// MARK: - WalkthroughPageViewControllerDelegate

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate{
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}

