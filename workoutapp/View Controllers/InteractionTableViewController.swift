//
//  InteractionTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-01-14.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import RealmSwift

class InteractionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var interactionsDict : [String:[Interaction]] = Interaction.getWithDate()
    var dates : [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        interactionsDict = Interaction.getWithDate()
        dates = Array(interactionsDict.keys).sorted(by: >)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return interactionsDict.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactionsDict[dates[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if dates.count>0{
            return dates[section]
        }
        else{
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InteractionTableCell", for: indexPath) as? InteractionTableViewCell
        else{
                return InteractionTableViewCell()
        }
        cell.typeLabel.text = interactionsDict[dates[indexPath.section]]![indexPath.row].identifier
        cell.usefulLabel.text = interactionsDict[dates[indexPath.section]]![indexPath.row].wasUseful ? "useful" : " not useful"
        return cell
    }

}
