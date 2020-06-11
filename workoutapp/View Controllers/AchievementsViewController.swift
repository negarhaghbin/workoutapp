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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Badge.update{()->() in
            notAchieved = Badge.getNotAchieved()
            achieved = Badge.getAchieved()
        }
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
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
            case 0:
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
        case 0:
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
