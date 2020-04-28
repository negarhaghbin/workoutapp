//
//  RoutineTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-15.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import CoreLocation


class RoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var section : RoutineSection?{
        didSet{
            refreshUI()
        }
    }
    
    var customizedSection : RoutineSection? = nil
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var selectedExercise = AppExercise()
    
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
        customizedSection = RoutineSection(title: section!.title, image: section!.image, exercises: section!.exercises)
        //customizedSection = section!.copy() as? RoutineSection
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
        cell.title.text = exercise.exercise?.name
        cell.previewImage.image = UIImage(named: (exercise.gifName + ".gif"))
        
        if(customizedSection?.exercises[indexPath.row].exercise?.name != ""){
            cell.selectionSwitch.setOn(true, animated: true)
        }
        else{
            cell.selectionSwitch.setOn(false, animated: true)
        }
        
        cell.selectionSwitch.tag = indexPath.row
        cell.selectionSwitch.addTarget(self, action: #selector(self.addRemoveExercise(_:)), for: .valueChanged)

        return cell
    }

    @IBAction func addRemoveExercise(_ sender: UISwitch!) {
        if(sender.isOn){
            customizedSection?.exercises[sender.tag] = section!.exercises[sender.tag]
        }
        else{
            customizedSection?.exercises[sender.tag] = AppExercise()
        }
    }
   
    @IBAction func start(_ sender: Any) {
        let startAlert = UIAlertController(title: "Are you ready?", message: "Your workout will start shortly after choosing yes.", preferredStyle: .alert)
        
        startAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            switch CLLocationManager.authorizationStatus() {
                case .authorizedWhenInUse, .authorizedAlways:
                    guard let currentLocation: CLLocationCoordinate2D = self.locationManager.location?.coordinate else { return }
                    let loc = location()
                    loc.set(lat:currentLocation.latitude , long:currentLocation.longitude)
                    loc.add(completion: {
                        let l = location.getMostRecordedLocation()
                        let destRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude),
                        radius: 1.0,
                        identifier: "home_location_id")
                        AppDelegate.locationManager.startMonitoring(for: destRegion)
                    })
                case .notDetermined, .restricted, .denied:
                    break
            }
            
            
                UIApplication.shared.isIdleTimerDisabled = true
                self.performSegue(withIdentifier: "startRoutine", sender:Any?.self)
            }))
        
        startAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        let repetitionAlert = UIAlertController(title: "Select the number of repetition", message: "", preferredStyle: .alert)
        
        repetitionAlert.addTextField(configurationHandler: {
            textField in
            textField.keyboardType = .numberPad
            textField.text = String(self.customizedSection!.repetition)
            
        })
        
        repetitionAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: {
            action in
            self.customizedSection?.repetition = Int((repetitionAlert.textFields!.first!.text)!)!
            self.present(startAlert, animated: true)
           }))
        
        self.present(repetitionAlert, animated: true)
       }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "startRoutine" {
            let vc = segue.destination as? StartRoutineViewController
            // Pass the selected object to the new view controller.
            customizedSection?.exercises = (customizedSection?.exercises.filter {
                $0.exercise != nil
                })!
            vc!.section = customizedSection
        }
        
        if segue.identifier == "showExercise", let destination = segue.destination as? ViewController {
            if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) {
                let exercise = section!.exercises[indexPath.row]
                destination.exercise = exercise
            }
        }
    }
    

}

// MARK: - EXTENSIONS

extension RoutineViewController: RoutineSelectionDelegate {
  func routineSelected(_ newRoutine: RoutineSection) {
    section = newRoutine
  }
}

