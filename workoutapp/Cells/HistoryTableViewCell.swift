//
//  HistoryTableViewCell.swift
//  workoutapp
//
//  Created by Negar on 2019-11-30.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var percentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progress.transform = progress.transform.scaledBy(x: 1, y: 10)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HistoryTableViewCell: updateProgressDelegate {
    func showToday(_ percentage: Float) {
        self.progress.progress = percentage/100.0
    }
    
    func showAllTime(_ p: Float) {
        self.progress.setProgress(p, animated: true)
    }
}
