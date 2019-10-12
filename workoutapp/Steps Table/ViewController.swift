//
//  ViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let StepCellReuseIdentifier = "StepTableViewCell"
    
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    internal let tapRecognizer1: UITapGestureRecognizer = UITapGestureRecognizer()
    
    var video : Video?{
        didSet{
            refreshUI()
        }
    }
    
    private func refreshUI(){
        loadView()
        titleLabel.text=video?.title
        subtitleView.text=video?.subtitle
        previewImageView.image=UIImage(named: ((video?.videoThumbURL.path) ?? ""))
        tapRecognizer1.addTarget(self, action: Selector(("tap:")))
        previewImageView.gestureRecognizers = []
        previewImageView.gestureRecognizers!.append(tapRecognizer1)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (video?.steps.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StepCellReuseIdentifier, for: indexPath) as? StepTableViewCell else {
            return StepTableViewCell()
        }
        let step = video?.steps[indexPath.row]
        cell.numberLabel.text = String(step!.0)
        cell.descriptionLabel.text = step!.1

        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let videoURL = video?.url
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        present(playerViewController, animated: true) {
            player.play()
        }
    }
}

extension ViewController: ExerciseSelectionDelegate {
  func exerciseSelected(_ newExercise: Video) {
    video = newExercise
  }
}

