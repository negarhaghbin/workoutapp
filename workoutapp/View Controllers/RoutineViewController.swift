//
//  RoutineTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-15.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit


class RoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var section : RoutineSection?{
        didSet{
            refreshUI()
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var selectedExercise = ExerciseModel()
    
    let RoutineTableReuseIdentifier = "RoutineTableReuseIdentifier"
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func refreshUI(){
        loadView()
        headerImage.image = imageWithImage( image: UIImage(named:section!.image.url.path)!, scaledToSize: CGSize(width: view.frame.width, height: view.frame.width/3))
        self.title = section?.title
        descriptionLabel.text = section?.getDescription()
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section!.exercises.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTableReuseIdentifier, for: indexPath) as? RoutineTableViewCell
            else{
                return RoutineTableViewCell()
        }
        
        let exercise = section!.exercises[indexPath.row]
        cell.title.text = exercise.title
        cell.previewImage.image = UIImage(named: (exercise.gifName + ".gif"))

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "startRoutine" {
            let vc = segue.destination as? StartRoutineViewController
            // Pass the selected object to the new view controller.
            vc!.section = section
        }
        
        if segue.identifier == "showExercise", let destination = segue.destination as? ViewController {
            if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) {
                let exercise = section!.exercises[indexPath.row]
                destination.exercise = exercise
            }
        }
    }
    

}

extension RoutineViewController: RoutineSelectionDelegate {
  func routineSelected(_ newRoutine: RoutineSection) {
    section = newRoutine
  }
}
