//
//  TableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var videos: [Video] = []
    let VideoCellReuseIdentifier = "VideoTableViewCell"
    let sections=["Total Body", "Upper Body", "Abs", "Lower Body"]
    var sectionsCount = Array(repeating:0 , count:4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videos = Video.localVideos()
        for video in videos{
            for (index,section) in sections.enumerated(){
                if section == video.section{
                    sectionsCount[index]+=1
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsCount[section]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoCellReuseIdentifier, for: indexPath) as? VideoTableViewCell else {
            return VideoTableViewCell()
        }
        let index=(indexPath.section * sectionsCount[indexPath.section==0 ? 0:indexPath.section-1]) + indexPath.row
        
        let video = videos[index]
        cell.titleLabel.text = video.title
        cell.previewImageView.image = UIImage(named: (video.thumbURL.path))
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let vc=segue.destination as! ViewController
        // Pass the selected object to the new view controller.
        let indexPath=tableView.indexPathForSelectedRow
        let sectionCount = (indexPath?.section != 0) ? sectionsCount[indexPath!.section - 1] : sectionsCount[0]

        let index = (indexPath!.section) * sectionCount + (indexPath!.row)
        vc.video = videos[index]
        
    }
    

}
