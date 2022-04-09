//
//  NewWorkoutPopupViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import SearchTextField

class NewWorkoutPopupViewController: UIViewController{
    
    // MARK: - Outlets
    
    @IBOutlet weak var boxTitle: UILabel!
    @IBOutlet weak var pickerBackground: UIView!
    @IBOutlet weak var nameField: SearchTextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var durationPickerMinLabel: UILabel!
    @IBOutlet weak var durationPickerSecLabel: UILabel!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabelLabel: UILabel!
    @IBOutlet weak var typeLabelLabel: UILabel!
    @IBOutlet weak var countField: UITextField!
    
    // MARK: - Variables
    
    let types = [ExerciseType.total.rawValue, ExerciseType.upper.rawValue, ExerciseType.abs.rawValue, ExerciseType.lower.rawValue]
    let exercises = Exercise.loadExercises()
    var exerciseNames : [String] = []
    
    var countable = false
    
    var diaryItem : DiaryItem? {
        didSet {
            refreshUI()
        }
    }
    
    enum PickerViewTags: Int {
        case date = 0
        case type
        case duration
    }
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeLabel.text = types[0]
        saveButton.isHighlighted = true
        saveButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dismissKey()
        tabBarController?.tabBar.isHidden = true
        if dateLabel.text == "Label" {
            dateLabel.text = Date().makeDateString()
        }
        
        for exercise in exercises {
            exerciseNames.append(exercise.name)
        }
        
        nameField.filterStrings(exerciseNames)
        countField.isHidden = true
        durationLabel.isHidden = false
//        addPickerLabels(picker: durationPicker, vc: self)
        if let name = nameField.text, let type = typeLabel.text, (nameField.text != "" && AppExercise.hasExercise(name: name, type: type)) {
            nameField.isEnabled = false
            nameField.isUserInteractionEnabled = false
            typeLabel.isEnabled = false
            typeLabel.isUserInteractionEnabled = false
            nameLabelLabel.isEnabled = false
            nameLabelLabel.isUserInteractionEnabled = false
            typeLabelLabel.isEnabled = false
            typeLabelLabel.isUserInteractionEnabled = false
        }
        
        datePicker.maximumDate = Date()
    }
    
    // MARK: - Helpers
    
    private func refreshUI() {
        loadView()
        boxTitle.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        guard let diaryItem = diaryItem else { return }
        
        nameField.text = diaryItem.exercise?.name
        typeLabel.text = diaryItem.exercise?.type
        dateLabel.text = diaryItem.dateString
        if (diaryItem.duration?.getTimeDuration() == "") {
            countable = true
            countField.isHidden = false
            durationLabel.isHidden = true
            countField.text = diaryItem.duration?.getDuration()
            countField.keyboardType = .numberPad
        } else {
            countField.isHidden = true
            durationLabel.isHidden = false
            durationLabel.text = diaryItem.duration?.getDuration()
        }
    }
    
    private func getExercise() -> Exercise {
        guard let name = nameField.text, let type = typeLabel.text else { return Exercise() }
        
        if Exercise.isNew(ck: Exercise.getCompoundKey(name: name, type: type)) {
            let exercise = Exercise(name: name, type: type)
            exercise.add()
            return exercise
        } else {
            return Exercise.getObject(ck: Exercise.getCompoundKey(name: name, type: type))
        }
    }
    
    private func updateDiaryItem(exercise: Exercise) {
        guard let diaryItem = diaryItem else { return }

        if countable {
            var count = 0
            if let countText = countField.text, countText != "No sets" {
                count = Int(countText)!
            }
            if let dateText = dateLabel.text {
                DiaryItem.update(uuid: diaryItem.uuid, e: exercise, d: Duration(countPerSet: count), date: dateText)
            }
        } else {
            if let dateText = dateLabel.text, let durationText = durationLabel.text {
                DiaryItem.update(uuid: diaryItem.uuid, e: exercise, d: Duration(durationInSeconds: reverSecondsToString(time: durationText)), date: dateText)
            }
        }
    }
    
    private func addDiaryItem(exercise: Exercise) {
        if countable {
            if let countText = countField.text, let dateText = dateLabel.text {
                diaryItem = DiaryItem(e: exercise, d: Duration(countPerSet: Int(countText)), date: dateText)
            }
        } else {
            if let dateText = dateLabel.text, let durationText = durationLabel.text {
                diaryItem = DiaryItem(e: exercise, d: Duration(durationInSeconds: reverSecondsToString(time: durationText)), date: dateText)
            }
        }
        if let diaryItem = diaryItem {
            diaryItem.add()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        saveButton.isHighlighted = (nameField.text?.isEmpty == true)
        saveButton.isEnabled = (nameField.text?.isEmpty == false)
        
        if (nameField.text?.isEmpty == false) {
            if let nameText = nameField.text, let index = exerciseNames.firstIndex(of: nameText) {
                typeLabel.text = exercises[index].type
            }
        }
    }
    
    @IBAction func showDatePicker(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        typePicker.isHidden = true
        datePicker.isHidden = false
        durationPicker.isHidden = true
        durationPickerMinLabel.isHidden = true
        durationPickerSecLabel.isHidden = true
        pickerBackground.isHidden = false
    }
    
    @IBAction func showTypePicker(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        datePicker.isHidden = true
        typePicker.isHidden = false
        durationPicker.isHidden = true
        durationPickerMinLabel.isHidden = true
        durationPickerSecLabel.isHidden = true
        pickerBackground.isHidden = false
    }
    
    @IBAction func showDurationPicker(_ sender: Any) {
        view.endEditing(true)
        datePicker.isHidden = true
        typePicker.isHidden = true
        durationPicker.isHidden = false
        durationPickerMinLabel.isHidden = false
        durationPickerSecLabel.isHidden = false
        pickerBackground.isHidden = false
    }
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
        datePicker.date = sender.date
        dateLabel.text = sender.date.makeDateString()
    }

    @IBAction func changeName(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
        let exercise = getExercise()
        
        if diaryItem != nil {
            updateDiaryItem(exercise: exercise)
        } else {
            addDiaryItem(exercise: exercise)
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - ExerciseSelectionDelegate

extension NewWorkoutPopupViewController: ExerciseSelectionDelegate{
    func exerciseSelected(_ newExercise: AppExercise) {
        if let diaryItem = diaryItem {
            diaryItem.exercise = newExercise.exercise
            diaryItem.duration!.durationInSeconds = newExercise.durationInSeconds!.durationInSeconds
        }
    }
}

// MARK: - UIPickerView
extension NewWorkoutPopupViewController:  UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case PickerViewTags.type.rawValue:
            return 1
        case PickerViewTags.duration.rawValue:
            return 2
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case PickerViewTags.type.rawValue:
            return types.count
            
        case PickerViewTags.duration.rawValue:
            return 60
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case PickerViewTags.type.rawValue:
            return types[row]
            
        case PickerViewTags.duration.rawValue:
            return String(row)
            
        default:
            return "unknown"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case PickerViewTags.type.rawValue:
            typeLabel.text = types[pickerView.selectedRow(inComponent: 0)]
            
        case PickerViewTags.duration.rawValue:
            durationLabel.text = SecondsToString(time: pickerView.selectedRow(inComponent: 0)*60 + pickerView.selectedRow(inComponent: 1))
            
        default:
            break
        }
        
    }
    
    
}
