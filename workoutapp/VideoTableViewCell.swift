//
//  TableViewCell.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var video: Video? = nil {
      didSet {
        updateViews()
      }
    }
    
    func updateViews() {
      titleLabel.text = video?.title
      titleLabel.font = UIFont.systemFont(ofSize: 24.0)
      
      let image = UIImage(named: (video?.thumbURL.path)!)
      previewImageView.image = image
      
      subtitleLabel.text = video?.subtitle
      subtitleLabel.font = UIFont.systemFont(ofSize: 14.0)
      subtitleLabel.numberOfLines = 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subtitleLabel.text="hello"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(false, animated: false)
    }
    
    // MARK - Obligatory Inits
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      backgroundColor = .blue
    }

}
