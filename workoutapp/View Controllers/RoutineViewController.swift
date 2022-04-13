//
//  RoutineTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-15.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import CoreLocation


class RoutineViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
    
    // MARK: - Properties
    
    let repetitionAlert = UIAlertController(title: "Select the number of repetitions", message: "", preferredStyle: .alert)
    let RoutineTableReuseIdentifier = "RoutineTableReuseIdentifier"
    
    var section: RoutineSection? {
        didSet {
            refreshUI()
        }
    }
    
    var repetitionPicker: UIPickerView = UIPickerView()
    let locationManager = CLLocationManager()
    var selectedExercise = AppExercise()
    var customizedSection : RoutineSection? = nil
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionLabel.text = customizedSection?.getDescription()
    }
    
    // MARK: - Helpers
    
    private func refreshUI(){
        loadView()
        headerImage.image = imageWithImage( image: UIImage(named:section!.image.url.path)!, scaledToSize: CGSize(width: view.frame.width, height: view.frame.width/3))
        self.title = section?.title
        customizedSection = RoutineSection(title: section!.title, image: section!.image, exercises: section!.exercises)
        let startAlert = createStartAlert()
        createRepetitionAlert(startAlert: startAlert)
        repetitionPicker.delegate = self
        repetitionPicker.dataSource = self
    }
    
    func createStartAlert() -> UIAlertController {
        let startAlert = UIAlertController(title: "Are you ready?", message: "Your workout will start shortly after choosing yes.", preferredStyle: .alert)
        
        startAlert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                if let currentLocation = self.locationManager.location?.coordinate {
                    let loc = location()
                    loc.set(lat:currentLocation.latitude, long:currentLocation.longitude)
                    loc.add() {
                        let l = location.getMostRecordedLocation()
                        let destRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude), radius: 1.0, identifier: "home_location_id")
                        AppDelegate.locationManager.startMonitoring(for: destRegion)
                    }
                }
                
            default:
                break
            }
            
            UIApplication.shared.isIdleTimerDisabled = true
            self.performSegue(withIdentifier: "startRoutine", sender: self)
        })
        
        startAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        return startAlert
    }
    
    func createRepetitionAlert(startAlert: UIAlertController){
        repetitionAlert.addTextField(configurationHandler: { [weak self] textField in
            guard let strongSelf = self else { return }
            
            textField.inputView = strongSelf.repetitionPicker
            textField.text = String(strongSelf.customizedSection!.repetition)
            
        })
        
        repetitionAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
            self?.customizedSection?.repetition = Int((self?.repetitionAlert.textFields!.first!.text)!)!
            self?.present(startAlert, animated: true)
        }))
    }
    
    // MARK: - Actions
    
    @IBAction func addRemoveExercise(_ sender: UISwitch) {
        (sender.isOn == true) ? (customizedSection?.exercises[sender.tag] = section!.exercises[sender.tag]) : (customizedSection?.exercises[sender.tag] = AppExercise())
        
        if customizedSection?.exercises.filter({$0.exercise != nil}).isEmpty == true {
            startButton.backgroundColor = UIColor.systemGray3
            startButton.isEnabled = false
        } else {
            startButton.backgroundColor = ColorPalette.mainPink
            startButton.isEnabled = true
        }
        descriptionLabel.text = customizedSection?.getDescription()
    }
    
    @IBAction func start(_ sender: Any) {
        present(repetitionAlert, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startRoutine" {
            if let vc = segue.destination as? StartRoutineViewController, let exercises = customizedSection?.exercises.filter({$0.exercise != nil}) {
                customizedSection?.exercises = exercises
                vc.section = customizedSection
            }
        }
        
        if segue.identifier == "showExercise", let destination = segue.destination as? ViewController {
            if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) {
                let exercise = section!.exercises[indexPath.row]
                destination.exercise = exercise
            }
        }
    }
}

// MARK: - Table view data source

extension RoutineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section!.exercises.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTableReuseIdentifier, for: indexPath) as? RoutineTableViewCell else { return RoutineTableViewCell() }
        
        let exercise = section!.exercises[indexPath.row]
        cell.title.text = exercise.exercise?.name
        cell.previewImage.image = UIImage(named: (exercise.gifName + ".gif"))
        
        if let _ = customizedSection?.exercises[indexPath.row].exercise {
            cell.selectionSwitch.setOn(true, animated: false)
        } else {
            cell.selectionSwitch.setOn(false, animated: false)
        }
        
        cell.selectionSwitch.tag = indexPath.row
        cell.selectionSwitch.addTarget(self, action: #selector(self.addRemoveExercise(_:)), for: .valueChanged)
        
        return cell
    }
}

// MARK: - RoutineSelectionDelegate

extension RoutineViewController: RoutineSelectionDelegate {
    func routineSelected(_ newRoutine: RoutineSection) {
        section = newRoutine
    }
}

// MARK: - UIPicker

extension RoutineViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        repetitionAlert.textFields?.first?.text = String(pickerView.selectedRow(inComponent: 0)+1)
    }
}
