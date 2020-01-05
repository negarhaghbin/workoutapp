//
//  ActivityViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-12-31.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit


protocol updateProgressDelegate : class{
    func showToday(_ percentage:Float)
    func showAllTime(_ p:Float)
}

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var delegate : updateProgressDelegate!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tView: UITableView!
    var data = dailyRoutine.getDictionary()
    let titles=["Total Body", "Upper Body", "Abs", "Lower Body"]
    let strokeColors=[UIColor.red, UIColor.blue, UIColor.systemYellow, UIColor.green]
    var percentages : [Float] = []
    let cellIdentifier = "HistoryCellIdentifier"
    var totalTime : [Float] = []
    var max = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let index = segmentController.selectedSegmentIndex
        switch index {
        case 0:
            data = dailyRoutine.getDictionary()
            for title in titles{
                let percentage = (Float(data[title]!)*100.0)/(2*60.0)
                percentages.append(percentage)
            }
        case 1:
            data = dailyRoutine.getAllDictionary()
            for title in titles{
                totalTime.append(Float(data[title]!))
            }
            max = Int(totalTime.max()!)
        
        default:
            print("not familiar segment")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HistoryTableViewCell
        else{
                return HistoryTableViewCell()
        }
        let index = segmentController.selectedSegmentIndex
        let title = titles[indexPath.section]
        cell.progress.tintColor = strokeColors[indexPath.section]
        switch index {
        case 0:
            if(percentages[indexPath.section] > 100){
                cell.percentage.text = "100.0%"
            }
            else{
                cell.percentage.text = String(format: "%.2f %%",percentages[indexPath.section])
            }
            //print(index)
            cell.showToday(percentages[indexPath.section])
            cell.subtitle.isHidden=false
        case 1:
            cell.percentage.text = timeString(seconds:data[title]!)
            if self.max>0{ cell.showAllTime(self.totalTime[indexPath.section]/Float(self.max))
            }
            else{
                cell.showAllTime(0.0)
            }
            
            cell.subtitle.isHidden=true
        
        default:
            print("not familiar segment")
        }
        
        return cell
    }
    
//    func reloadProgress(index: Int) {
//        for indexPath in tView.indexPathsForVisibleRows ?? [] {
//
//            if (tView.cellForRow(at: indexPath) as? HistoryTableViewCell) != nil {
//                switch index {
//                case 0:
//                    delegate?.showToday(percentages[indexPath.section])
//                case 1:
//                    delegate?.showAllTime(self.totalTime[indexPath.section]/Float(self.max))
//                       
//                default:
//                    print("not familiar segment")
//                }
//                
//               
//            }
//        }
//    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        let index = segmentController.selectedSegmentIndex
        switch index {
        case 0:
            data = dailyRoutine.getDictionary()
            for title in titles{
                let percentage = (Float(data[title]!)*100.0)/(2*60.0)
                percentages.append(percentage)
            }
        case 1:
            data = dailyRoutine.getAllDictionary()
            for title in titles{
                totalTime.append(Float(data[title]!))
            }
            max = Int(totalTime.max()!)
        
        default:
            print("not familiar segment")
        }
        tView.reloadData()
        //reloadProgress(index: index)
    }
    
    func timeString(seconds:Int) -> String {
        let m = seconds / 60 % 60
        let s = seconds % 60
        return String(format:"%02i:%02i", m, s)
    }
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
