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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
