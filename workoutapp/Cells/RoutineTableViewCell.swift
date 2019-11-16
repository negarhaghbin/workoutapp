//
//  RoutineTableViewCell.swift
//  workoutapp
//
//  Created by Negar on 2019-11-15.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {
//    var video : Video?{
//        didSet{
//            refreshUI()
//        }
//    }

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
