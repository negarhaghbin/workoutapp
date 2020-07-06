//
//  AchievementsViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-05-20.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var notAchieved : [Badge] = []
    var achieved : [Badge] = []
    var newlyAchieved : [Badge] = []
    
    let ACHIEVED_SECTION = 0
    let UPCOMING_SECTION = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Badge.update{()->() in
            notAchieved = Badge.getNotAchieved()
            achieved = Badge.getAchieved()
            newlyAchieved = Badge.getNewlyAchieved()
            Badge.resetNewlyAchieved()
            showCongragulationsMessage(newlyAchieved: newlyAchieved)
            
        }
        tableView.reloadData()
        
    }
    
    func showCongragulationsMessage(newlyAchieved: [Badge]){
        guard self.newlyAchieved.count > 0 else { return }
        let badge = self.newlyAchieved.first
        
        func removeAndShowNextMessage() {
            self.newlyAchieved.removeFirst()
            self.showCongragulationsMessage(newlyAchieved: newlyAchieved)
        }
        
        let alert = UIAlertController(title: "Congratulations!", message: "You have successfully achieved \(badge!.title) badge.", preferredStyle: .alert)
        
        let alertImage = UIImage(named: badge!.imageName)
        alert.addImage(image: alertImage!)
        alert.addAction(UIAlertAction(title: "Hooray!", style: .default){ (action) in
                removeAndShowNextMessage()
        })
            self.present(alert, animated: true)
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case ACHIEVED_SECTION:
            return achieved.count
        default:
            return notAchieved.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "achCell", for: indexPath) as? AchievementsTableViewCell{
            switch indexPath.section {
            case ACHIEVED_SECTION:
                cell.title.text = achieved[indexPath.row].title
                cell.badgeImage.image = UIImage(named: achieved[indexPath.row].imageName)
                cell.descriptionLabel.text = achieved[indexPath.row].specification
                setProgressForAchievedBadge(cell: cell, indexPath: indexPath)
                return cell
            default:
                cell.title.text = notAchieved[indexPath.row].title
                cell.badgeImage.image = UIImage(named: notAchieved[indexPath.row].imageName)
                cell.descriptionLabel.text = notAchieved[indexPath.row].specification
                setProgressForNotAchievedBadge(cell: cell, indexPath: indexPath)
                return cell
            }
        }
        else{
            return AchievementsTableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case ACHIEVED_SECTION:
            return "Achieved"
        default:
            return "Upcoming"
        }
    }
    
    func setProgressForNotAchievedBadge(cell: AchievementsTableViewCell, indexPath: IndexPath){
        let progress = notAchieved[indexPath.row].getProgressBetween0and1()
        cell.progressBar?.setProgress(progress.0, animated: false)
        cell.progressLabel.text = progress.1
    }
    
    func setProgressForAchievedBadge(cell: AchievementsTableViewCell, indexPath: IndexPath){
        cell.progressBar?.setProgress(1, animated: false)
        cell.progressLabel.text = achieved[indexPath.row].getProgressBetween0and1().1
    }

}
