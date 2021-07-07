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
        self.isUserInteractionEnabled = !isStepCell
        self.durationLabel.isEnabled = !isStepCell
        self.nameLabel.isEnabled = !isStepCell
        
        if isStepCell{
            self.nameLabel.text = "Steps"
            self.durationLabel.text = "Not Available"
            
            if let step = stepsCount {
                if step.first!.count != -1{
                    self.durationLabel.text = String(step.first!.count)
                }
            }
        }
        else{
            self.nameLabel.text = diaryItem!.exercise?.name
            let duration = diaryItem!.duration
            self.durationLabel.text = duration?.getDuration()
        }
    }

}
