//
//  RoutineTableViewCell.swift
//  workoutapp
//
//  Created by Negar on 2019-11-15.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionSwitch: UISwitch!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
