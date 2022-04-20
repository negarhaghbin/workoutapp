//
//  AchievementsViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-05-20.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var notAchieved: [Badge] = []
    var achieved: [Badge] = []
    var newlyAchieved: [Badge] = []
    
    enum Sections: Int, CaseIterable{
        case achieved = 0
        case upcoming
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Badge.update {
            notAchieved = Badge.getNotAchieved()
            achieved = Badge.getAchieved()
            newlyAchieved = Badge.getNewlyAchieved()
            Badge.resetNewlyAchieved()
            showCongragulationsMessage(newlyAchieved: newlyAchieved)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    func showCongragulationsMessage(newlyAchieved: [Badge]) {
        guard !self.newlyAchieved.isEmpty, let badge = self.newlyAchieved.first else { return }
        
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
        
            present(alert, animated: true)
        }
}

// MARK: - UITable

extension AchievementsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let achievementsSection = Sections(rawValue: section) else { fatalError() }
        
        switch achievementsSection {
        case .achieved:
            return achieved.count
        case .upcoming:
            return notAchieved.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.badgeCellIdentifier, for: indexPath) as? AchievementsTableViewCell else { return AchievementsTableViewCell() }
        guard let achievementsSection = Sections(rawValue: indexPath.section) else { fatalError() }
        
        switch achievementsSection {
        case .achieved:
            cell.setValues(badge: achieved[indexPath.row])
            cell.setProgress(for: achieved[indexPath.row], achieved: true)
            return cell
        case .upcoming:
            cell.setValues(badge: notAchieved[indexPath.row])
            cell.setProgress(for: notAchieved[indexPath.row], achieved: false)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let achievementsSection = Sections(rawValue: section) else { return "" }
        
        switch achievementsSection {
        case .achieved:
            return "Achieved"
        case .upcoming:
            return "Upcoming"
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let achievementsSection = Sections(rawValue: section) else { return "" }
        
        switch achievementsSection {
        case .achieved:
            if achieved.isEmpty {
                return "You have not achieved any badge yet."
            }
        case .upcoming:
            if notAchieved.isEmpty {
                return "You have achieved all of the badges."
            }
        }
        
        return ""
    }

}
