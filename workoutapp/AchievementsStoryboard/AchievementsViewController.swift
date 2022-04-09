//
//  AchievementsViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-05-20.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController{
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var notAchieved : [Badge] = []
    var achieved : [Badge] = []
    var newlyAchieved : [Badge] = []
    let badgeCellIdentifier = "achCell"
    
    enum sections: Int, CaseIterable{
        case achieved = 0
        case upcoming
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Badge.update{
            notAchieved = Badge.getNotAchieved()
            achieved = Badge.getAchieved()
            newlyAchieved = Badge.getNewlyAchieved()
            Badge.resetNewlyAchieved()
            showCongragulationsMessage(newlyAchieved: newlyAchieved)
            
        }
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    func showCongragulationsMessage(newlyAchieved: [Badge]){
        guard self.newlyAchieved.count > 0, let badge = self.newlyAchieved.first else { return }
        
        func removeAndShowNextMessage() {
            self.newlyAchieved.removeFirst()
            self.showCongragulationsMessage(newlyAchieved: newlyAchieved)
        }
        
        let alert = UIAlertController(title: "Congratulations!", message: "You have successfully achieved \(badge.title) badge.", preferredStyle: .alert)
        
        if let alertImage = UIImage(named: badge.imageName) {
            alert.addImage(image: alertImage)
            alert.addAction(UIAlertAction(title: "Hooray!", style: .default) { (action) in
                removeAndShowNextMessage()
            })
        }
        
            self.present(alert, animated: true)
        }
}

extension AchievementsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case sections.achieved.rawValue:
            return achieved.count
        default:
            return notAchieved.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: badgeCellIdentifier, for: indexPath) as? AchievementsTableViewCell else{
            return AchievementsTableViewCell()
        }
        
        switch indexPath.section {
        case sections.achieved.rawValue:
            cell.setValues(badge: achieved[indexPath.row])
            cell.setProgress(for: achieved[indexPath.row], achieved: true)
            return cell
        default:
            cell.setValues(badge: notAchieved[indexPath.row])
            cell.setProgress(for: notAchieved[indexPath.row], achieved: false)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case sections.achieved.rawValue:
            return "Achieved"
        case sections.upcoming.rawValue:
            return "Upcoming"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section{
        case sections.achieved.rawValue:
            if achieved.count == 0{
                return "You have not achieved any badge yet."
            }
        case sections.upcoming.rawValue:
            if notAchieved.count == 0{
                return "You have achieved all of the badges."
            }
        default:
            return ""
        }
        
        return ""
    }

}
