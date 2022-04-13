//
//  InteractionTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-01-14.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class InteractionTableViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    lazy var interactionsDict: [String: [Interaction]] = Interaction.getWithDate()
    var dates: [String] = []
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        interactionsDict = Interaction.getWithDate()
        dates = Array(interactionsDict.keys).sorted(by: >)
    }
}

// MARK: - TableViewController

extension InteractionTableViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactionsDict.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactionsDict[dates[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dates.isEmpty ? "" : dates[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InteractionTableCell", for: indexPath) as? InteractionTableViewCell, let interaction = interactionsDict[dates[indexPath.section]] else { return InteractionTableViewCell() }
        
        cell.typeLabel.text = interaction[indexPath.row].identifier
        cell.usefulLabel.text = interaction[indexPath.row].wasUseful ? "useful" : " not useful"
        return cell
    }

}
