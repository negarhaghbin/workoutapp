//
//  AchievementsTableViewCell.swift
//  workoutapp
//
//  Created by Negar on 2020-05-20.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // MARK: - TableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Helpers
    
    func setValues(badge: Badge){
        title.text = badge.title
        badgeImage.image = UIImage(named: badge.imageName)
        descriptionLabel.text = badge.specification
    }
    
    func setProgress(for badge: Badge, achieved: Bool){
        if achieved {
            progressBar?.setProgress(1, animated: false)
            progressLabel.text = badge.getProgressBetween0and1().1
        } else {
            let progress = badge.getProgressBetween0and1()
            progressBar?.setProgress(progress.0, animated: false)
            progressLabel.text = progress.1
        }
    }

}
