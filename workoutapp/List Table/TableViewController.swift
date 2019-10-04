//
//  TableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

struct Section{
    var title: String
    var exercises : [Video]
}

class TableViewController: UITableViewController {
    var videos: [Video] = []
    let VideoCellReuseIdentifier = "VideoTableViewCell"
    var sections : [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videos = Video.localVideos()
        initSections()
        for video in videos{
            for (index,section) in sections.enumerated(){
                if section.title == video.section{
                    sections[index].exercises.append(video)
                }
            }
        }
    }
    
    func initSections(){
        let titles=["Total Body", "Upper Body", "Abs", "Lower Body"]
        for title in titles{
            sections.append(Section(title: title, exercises: []))
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].exercises.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoCellReuseIdentifier, for: indexPath) as? VideoTableViewCell else {
            return VideoTableViewCell()
        }
        let index=(indexPath.section * sections[indexPath.section==0 ? 0:indexPath.section-1].exercises.count) + indexPath.row
        
        let video = videos[index]
        cell.titleLabel.text = video.title
        cell.previewImageView.image = UIImage(named: (video.thumbURL.path))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.9, alpha: 1)
        //(view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let vc=segue.destination as! ViewController
        // Pass the selected object to the new view controller.
        let indexPath=tableView.indexPathForSelectedRow
        let sectionCount = (indexPath?.section != 0) ? sections[indexPath!.section - 1].exercises.count : sections[0].exercises.count

        let index = (indexPath!.section) * sectionCount + (indexPath!.row)
        vc.video = videos[index]
        
    }
    

}
