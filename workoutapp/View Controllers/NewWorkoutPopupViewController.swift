//
//  NewWorkoutPopupViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import SearchTextField

class NewWorkoutPopupViewController: UIViewController, ExerciseSelectionDelegate {
    @IBOutlet weak var boxTitle: UILabel!
    @IBOutlet weak var pickerBackground: UIView!
    @IBOutlet weak var nameField: SearchTextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabelLabel: UILabel!
    @IBOutlet weak var typeLabelLabel: UILabel!
    @IBOutlet weak var countField: UITextField!
    let types=[ExerciseType.total.rawValue, ExerciseType.upper.rawValue, ExerciseType.abs.rawValue, ExerciseType.lower.rawValue]
    let exercises = Exercise.loadExercises()
    var exerciseNames : [String] = []
    
    var countable = false
    
    var diaryItem : DiaryItem?{
        didSet{
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeLabel.text = types[0]
        saveButton.isHighlighted = true
        saveButton.isEnabled = false
        
    }
    
    func exerciseSelected(_ newExercise: AppExercise) {
        diaryItem!.exercise = newExercise.exercise
        diaryItem?.duration!.durationInSeconds = newExercise.durationInSeconds!.durationInSeconds
    }
    
    private func refreshUI(){
        loadView()
        boxTitle.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        datePicker.maximumDate = Date()
        nameField.text = diaryItem?.exercise?.name
        typeLabel.text = diaryItem?.exercise?.type
        dateLabel.text = diaryItem?.dateString
        if (diaryItem?.duration?.getTimeDuration() == ""){
            countable = true
            countField.isHidden = false
            durationLabel.isHidden = true
            countField.text = diaryItem!.duration?.getDuration()
            countField.keyboardType = .numberPad
        }
        else{
            countField.isHidden = true
            durationLabel.isHidden = false
            durationLabel.text = diaryItem!.duration?.getDuration()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dismissKey()
        boxTitle.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        if dateLabel.text == "Label"{
            dateLabel.text = Date().makeDateString()
        }
        for exercise in exercises{
            exerciseNames.append(exercise.name)
        }
        nameField.filterStrings(exerciseNames)
        countField.isHidden = true
        durationLabel.isHidden = false
        addPickerLabels(picker: durationPicker, vc: self)
        if (nameField.text != "" && AppExercise.hasExercise(name: nameField.text!, type: typeLabel.text!)){
            nameField.isEnabled = false
            nameField.isUserInteractionEnabled = false
            typeLabel.isEnabled = false
            typeLabel.isUserInteractionEnabled = false
            nameLabelLabel.isEnabled = false
            nameLabelLabel.isUserInteractionEnabled = false
            typeLabelLabel.isEnabled = false
            typeLabelLabel.isUserInteractionEnabled = false
        }
        
    }
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        if nameField.text == "" {
            saveButton.isHighlighted = true
            saveButton.isEnabled = false
        }
        else{
            if let index = exerciseNames.firstIndex(of: nameField.text!){
                typeLabel.text = exercises[index].type
            }
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
        dateLabel.text = sender.date.makeDateString()
    }

    @IBAction func changeName(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
        var e = Exercise()
        if Exercise.isNew(ck: Exercise.getCompoundKey(name: nameField.text!, type: typeLabel.text!)){
            e = Exercise(name: nameField.text!, type: typeLabel.text!)
            e.add()
        }
        else{
            e = Exercise.getObject(ck: Exercise.getCompoundKey(name: nameField.text!, type: typeLabel.text!))
        }
        if diaryItem != nil{
            if countable{
                var count = 0
                if countField.text != "No sets"{
                    count = Int(countField.text!)!
                }
                DiaryItem.update(uuid: diaryItem!.uuid, e: e, d: Duration(countPerSet: count), date: dateLabel.text!)
            }
            else{
                DiaryItem.update(uuid: diaryItem!.uuid, e: e, d: Duration(durationInSeconds: reverSecondsToString(time: durationLabel.text!)), date: dateLabel.text!)
            }
            
        }
        else{
            if countable{
                diaryItem = DiaryItem(e: e, d: Duration(countPerSet: Int(countField.text!)), date: dateLabel.text!)
            }
            else{
                diaryItem = DiaryItem(e: e, d: Duration(durationInSeconds: reverSecondsToString(time: durationLabel.text!)), date: dateLabel.text!)
            }
            diaryItem!.add()
            
        }
        
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }

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
