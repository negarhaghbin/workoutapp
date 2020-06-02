//
//  ViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
//import YouTubePlayer
import YoutubePlayer_in_WKWebView
import SystemConfiguration

class ViewController: UIViewController, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var durationView: UIView!
    var changeDurationAlert = UIAlertController(title: "Change exercise duration", message: nil, preferredStyle: .alert)
    var UIPicker: UIPickerView = UIPickerView()
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var youtubeView: WKYTPlayerView!
    var exercise : AppExercise?{
        didSet{
            refreshUI()
        }
    }
    
    private func refreshUI(){
        UIPicker.delegate = self
        UIPicker.dataSource = self
        addPickerLabels(picker: UIPicker, vc: self)
        if changeDurationAlert.textFields?.count==0{
            createChangeDurationAlert()
        }
        if (exercise?.videoURLString != "" && isConnectedToNetwork()){
            youtubeView.load(withVideoId: exercise!.videoURLString)
        }
        else{
            youtubeView.removeWebView() //might raise problems in future
            warningLabel.isHidden = false
            if(exercise?.videoURLString == ""){
                warningLabel.text = "There is no video tutorial for this exercise."
            }
            else if(!isConnectedToNetwork()){
                warningLabel.text = "You need internet connection for video tutorials."
            }
        }
        
        titleLabel.text = exercise?.exercise?.name
        durationLabel.text = SecondsToString(time: exercise!.durationS)
//        subtitleView.text=exercise?.getDescription()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createChangeDurationAlert(){
        changeDurationAlert.addTextField(configurationHandler: { textField in
            textField.inputView = self.UIPicker
        })
        
        changeDurationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        changeDurationAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let rd = self.changeDurationAlert.textFields?.first?.text {
                self.exercise?.setDuration(d: self.UIPicker.selectedRow(inComponent: 0)*60 + self.UIPicker.selectedRow(inComponent: 1))
                self.durationLabel.text = rd
            }
        }))
        
    }
    
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
        changeDurationAlert.textFields?.first?.text = SecondsToString(time: (pickerView.selectedRow(inComponent: 0))*60 + pickerView.selectedRow(inComponent: 1))
    }
    
    @IBAction func changeDuration(_ sender: Any) {
        present(changeDurationAlert, animated: false)
    }
}

extension ViewController: ExerciseSelectionDelegate {
  func exerciseSelected(_ newExercise: AppExercise) {
    exercise = newExercise
  }
}

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

