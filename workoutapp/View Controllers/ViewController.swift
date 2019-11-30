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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let StepCellReuseIdentifier = "StepTableViewCell"
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var youtubeView: WKYTPlayerView!
    var exercise : ExerciseModel?{
        didSet{
            refreshUI()
        }
    }
    
    private func refreshUI(){
        loadView()
        if (exercise?.videoURLString != "" && isConnectedToNetwork()){
            youtubeView.load(withVideoId: exercise!.videoURLString)
        }
        else{
            warningLabel.isHidden = false
            if(exercise?.videoURLString == ""){
                warningLabel.text = "There is no video tutorial for this exercise."
            }
            else if(!isConnectedToNetwork()){
                warningLabel.text = "You need internet connection for video tutorials."
            }
        }
        
        titleLabel.text = exercise?.title
        subtitleView.text=exercise?.getDescription()
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        guard let cell = tableView.dequeueReusableCell(withIdentifier: StepCellReuseIdentifier, for: indexPath) as? StepTableViewCell else {
//            return StepTableViewCell()
//        }
//        let step = video?.steps[indexPath.row]
//        cell.numberLabel.text = String(step!.0)
//        cell.descriptionLabel.text = step!.1
//
//        return cell
        return StepTableViewCell()
    }
}

extension ViewController: ExerciseSelectionDelegate {
  func exerciseSelected(_ newExercise: ExerciseModel) {
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

