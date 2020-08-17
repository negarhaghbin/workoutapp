//
//  WalkthroughViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-08-13.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var walkthroughPageViewController : WalkthroughPageViewController?
    var datePickerValue = ""
    var appSettings : notificationSettings = notificationSettings()
    let dateFormatter = DateFormatter()
    
    let SET_NAME_INDEX = 3
    let SEND_ON_INDEX = 4
    let SEND_AFTER_INDEX = 5
     
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "HH:mm"
        datePickerValue = dateFormatter.string(from: Date())
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dismissKey()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...SET_NAME_INDEX-1:
                for _ in index...SET_NAME_INDEX-1{
                    walkthroughPageViewController?.forwardPage()
                }
                
            case SET_NAME_INDEX:
                walkthroughPageViewController?.forwardPage()
            
            case SEND_ON_INDEX:
                walkthroughPageViewController?.forwardPage()
                
            case SEND_AFTER_INDEX:
                walkthroughPageViewController?.forwardPage()
                
            default:
                //UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            }
        }
        updateUI()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...SET_NAME_INDEX-1:
                walkthroughPageViewController?.forwardPage()
                
            case SET_NAME_INDEX:
                saveName()
                walkthroughPageViewController?.forwardPage()
            
            case SEND_ON_INDEX:
                updateSendOn()
                walkthroughPageViewController?.forwardPage()
                
            case SEND_AFTER_INDEX:
                updateSendAfter()
                walkthroughPageViewController?.forwardPage()
                
            default:
                //UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            }
        }
        updateUI()
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case SEND_ON_INDEX:
                datePicker.date = sender.date
                datePickerValue = dateFormatter.string(from: sender.date)
                
            case SEND_AFTER_INDEX:
                datePicker.countDownDuration = sender.countDownDuration
                datePickerValue = MinutesToString(time: Int(sender.countDownDuration))
                
            default:
                break
            }
        }
    }
    
    func updateSendOn(){
        appSettings = notificationSettings.getSettings()
        appSettings.setTime(value: datePickerValue)
        appSettings.setUpTimeNotification()
    }
    
    func updateSendAfter(){
        appSettings = notificationSettings.getSettings()
        appSettings.setSendAfter(value: Int(datePicker.countDownDuration))
    }
    
    func updateUI(){
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...SET_NAME_INDEX-1:
                nextButton.setTitle("NEXT", for: .normal)
                nextButton.isEnabled = true
                nextButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.3137254902, blue: 0.6666666667, alpha: 1)
                skipButton.isHidden = false
                textField.isHidden = true
                datePicker.isHidden = true
            
            case SET_NAME_INDEX:
                nextButton.setTitle("SAVE", for: .normal)
                nextButton.backgroundColor = UIColor.systemGray3
                nextButton.isEnabled = false
                skipButton.isHidden = false
                textField.isHidden = false
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                {_ in
                    let textCount = self.textField!.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    self.nextButton.isEnabled = textIsNotEmpty
                    if self.nextButton.isEnabled{
                        self.nextButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.3137254902, blue: 0.6666666667, alpha: 1)
                    }
                })
                datePicker.isHidden = true
            
            case SEND_ON_INDEX:
                nextButton.setTitle("SAVE", for: .normal)
                nextButton.isEnabled = true
                nextButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.3137254902, blue: 0.6666666667, alpha: 1)
                skipButton.isHidden = false
                textField.isHidden = true
                datePicker.isHidden = false
                datePicker.datePickerMode = .time
            
            case SEND_AFTER_INDEX:
                nextButton.setTitle("SAVE", for: .normal)
                nextButton.isEnabled = true
                nextButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.3137254902, blue: 0.6666666667, alpha: 1)
                skipButton.isHidden = false
                textField.isHidden = true
                datePicker.isHidden = false
                datePicker.datePickerMode = .countDownTimer
            
            default:
                nextButton.setTitle("GET STARTED", for: .normal)
                nextButton.isEnabled = true
                nextButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.3137254902, blue: 0.6666666667, alpha: 1)
                skipButton.isHidden = true
                datePicker.isHidden = true
            }
            pageControl.currentPage = index
        }
    }
    
    func saveName(){
        let specificPerson = User.getUser(uuid: UserDefaults.standard.string(forKey: "uuid")!)
        specificPerson.changeName(newName: textField.text!)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController{
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }

}

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate{
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
}

