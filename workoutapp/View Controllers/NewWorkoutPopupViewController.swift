//
//  NewWorkoutPopupViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class NewWorkoutPopupViewController: UIViewController, ExerciseSelectionDelegate {
    
    //var datePicker: UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var pickerBackground: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    let types=[ExerciseType.total.rawValue, ExerciseType.upper.rawValue, ExerciseType.abs.rawValue, ExerciseType.lower.rawValue]
    
    var exercise : ExerciseModel?{
        didSet{
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeLabel.text = types[0]
        saveButton.isHighlighted = true
        saveButton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    func exerciseSelected(_ newExercise: ExerciseModel) {
        exercise = newExercise
    }
    
    private func refreshUI(){
        loadView()
        nameField.text = exercise?.title
        typeLabel.text = exercise?.section
        durationLabel.text = SecondsToString(time: exercise!.durationS)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dismissKey()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        print(nameField.text)
        if nameField.text == "" {
            saveButton.isHighlighted = true
            saveButton.isEnabled = false
        }
        else{
            saveButton.isHighlighted = false
            saveButton.isEnabled = true
        }
    }
    @IBAction func showDatePicker(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        typePicker.isHidden = true
        datePicker.isHidden = false
        durationPicker.isHidden = true
        pickerBackground.isHidden = false
    }
    
    @IBAction func showTypePicker(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        datePicker.isHidden = true
        typePicker.isHidden = false
        durationPicker.isHidden = true
        pickerBackground.isHidden = false
    }
    @IBAction func showDurationPicker(_ sender: Any) {
        view.endEditing(true)
        datePicker.isHidden = true
        typePicker.isHidden = true
        durationPicker.isHidden = false
        pickerBackground.isHidden = false
    }
    @IBAction func changeDate(_ sender: UIDatePicker) {
        datePicker.date = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = dateFormatter.string(from: sender.date)
    }

    @IBAction func changeName(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
        let ce = CustomeExercise(name: nameField.text!, type: typeLabel.text!)
        let _ = DiaryItem(e: ce, d: durationLabel.text!, date: dateLabel.text!)
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
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

extension NewWorkoutPopupViewController:  UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1:
            return 1
        case 2:
            return 2
        default:
            print("unknown picker")
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return types.count
        case 2:
            return 60
        default:
            print("unknown picker")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return types[row]
        case 2:
            return String(row)
        default:
            print("unknown picker")
            return "unknown"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            typeLabel.text = types[pickerView.selectedRow(inComponent: 0)]
        case 2:
            durationLabel.text = SecondsToString(time: pickerView.selectedRow(inComponent: 0)*60 + pickerView.selectedRow(inComponent: 1))
        default:
            print("unknown picker")
        }
        
    }
    
    
}
