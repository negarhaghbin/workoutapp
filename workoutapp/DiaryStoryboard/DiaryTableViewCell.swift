//
//  DiaryTableViewCell.swift
//  workoutapp
//
//  Created by Negar on 2020-04-25.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValues(isStepCell: Bool, stepsCount: [Step]? = nil, diaryItem: DiaryItem? = nil){
        isUserInteractionEnabled = !isStepCell
        durationLabel.isEnabled = !isStepCell
        nameLabel.isEnabled = !isStepCell
        
        if isStepCell {
            nameLabel.text = "Steps"
            durationLabel.text = "Not Available"
            
            if let step = stepsCount, let firstSteps = step.first, firstSteps.count != -1 {
                durationLabel.text = String(firstSteps.count)
            }
        } else {
            if let diaryItem = diaryItem {
                nameLabel.text = diaryItem.exercise?.name
                let duration = diaryItem.duration
                durationLabel.text = duration?.getDuration()
            }
        }
    }

}
