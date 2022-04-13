//
//  ViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import SystemConfiguration

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var youtubeView: WKYTPlayerView!
    
    // MARK: - Properties
    
    var changeDurationAlert = UIAlertController(title: "Change exercise duration", message: nil, preferredStyle: .alert)
    var UIPicker: UIPickerView = UIPickerView()
    
    var exercise : AppExercise? {
        didSet {
            refreshUI()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    
    private func refreshUI() {
        UIPicker.delegate = self
        UIPicker.dataSource = self
        addPickerLabels(picker: UIPicker, vc: self)
        if changeDurationAlert.textFields?.isEmpty == true {
            createChangeDurationAlert()
        }
        
        setupVideoUI()
        if let exercise = exercise {
            titleLabel.text = exercise.exercise?.name
            durationLabel.text = exercise.durationInSeconds!.getDuration()
        }
    }
    
    private func setupVideoUI() {
        if (exercise?.videoURLString != "" && isConnectedToNetwork()) {
            youtubeView.load(withVideoId: exercise!.videoURLString)
        } else {
            youtubeView.removeWebView() //might raise problems in future
            warningLabel.isHidden = false
            if(exercise?.videoURLString == "") {
                warningLabel.text = "There is no video tutorial for this exercise."
            } else if(!isConnectedToNetwork()) {
                warningLabel.text = "You need internet connection for video tutorials."
            }
        }
    }
    
    func createChangeDurationAlert(){
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            if let rd = self.changeDurationAlert.textFields?.first?.text {
                self.exercise?.setDuration(d: self.UIPicker.selectedRow(inComponent: 0)*60 + self.UIPicker.selectedRow(inComponent: 1))
                self.durationLabel.text = rd
            }
        })
        
        changeDurationAlert.addTextField(configurationHandler: { textField in
            textField.inputView = self.UIPicker
            if textField.text == "" {
                saveAction.isEnabled = false
            }
        })
        
        changeDurationAlert.addAction(saveAction)
        
        changeDurationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    }
    
    // MARK: - Actions
    
    @IBAction func changeDuration(_ sender: Any) {
        present(changeDurationAlert, animated: false)
    }
}

// MARK: - UIPickerView
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let minutes = pickerView.selectedRow(inComponent: 0)
        let seconds = pickerView.selectedRow(inComponent: 1)
        changeDurationAlert.textFields?.first?.text = SecondsToString(time: (minutes * 60) + seconds)
        changeDurationAlert.actions.first?.isEnabled = true
    }
    
}

// MARK: - ExerciseSelectionDelegate

extension ViewController: ExerciseSelectionDelegate {
    func exerciseSelected(_ newExercise: AppExercise) {
        exercise = newExercise
    }
}

// MARK: - Network

extension ViewController{
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

