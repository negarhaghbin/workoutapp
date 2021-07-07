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
        self.title.text = badge.title
        self.badgeImage.image = UIImage(named: badge.imageName)
        self.descriptionLabel.text = badge.specification
    }
    
    func setProgress(for badge: Badge, achieved: Bool){
        if achieved{
            self.progressBar?.setProgress(1, animated: false)
            self.progressLabel.text = badge.getProgressBetween0and1().1
        }
        else{
            let progress = badge.getProgressBetween0and1()
            self.progressBar?.setProgress(progress.0, animated: false)
            self.progressLabel.text = progress.1
        }
    }

}
