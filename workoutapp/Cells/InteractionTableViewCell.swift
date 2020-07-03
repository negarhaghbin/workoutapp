//
//  InteractionTableViewCell.swift
//  workoutapp
//
//  Created by Negar on 2020-01-14.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class InteractionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usefulLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
