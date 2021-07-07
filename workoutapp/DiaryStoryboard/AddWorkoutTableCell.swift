//
//  AddWorkoutTableCell.swift
//  workoutapp
//
//  Created by Negar on 2020-04-24.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class AddWorkoutTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var addNewWorkout: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!

    // MARK: - TableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Helpers
    func setValues(isWorkout: Bool, exercise: AppExercise? = nil){
        self.addNewWorkout.isHidden = isWorkout
        self.titleLabel.isHidden = !isWorkout
        self.previewImageView.isHidden = !isWorkout
        
        if isWorkout{
            self.titleLabel.text = exercise!.exercise?.name
            self.previewImageView.image = UIImage(named: (exercise!.gifName + ".gif"))
        }
    }

}
