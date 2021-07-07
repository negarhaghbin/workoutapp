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
    let types=[ExerciseType.total.rawValue, ExerciseType.upper.rawValue, ExerciseType.abs.rawValue, ExerciseType.lower.rawValue]
    let exercises = Exercise.loadExercises()
    var exerciseNames : [String] = []
    
    var countable = false
    
    var diaryItem : DiaryItem?{
        didSet{
            refreshUI()
        }
    }
    
    enum pickerViewTags: Int{
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
        self.dismissKey()
        tabBarController?.tabBar.isHidden = true
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
        datePicker.maximumDate = Date()
        
    }
    
    // MARK: - Helpers
    
    private func refreshUI(){
        loadView()
        boxTitle.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
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
    
    private func getExercise()->Exercise{
        if Exercise.isNew(ck: Exercise.getCompoundKey(name: nameField.text!, type: typeLabel.text!)){
            let exercise = Exercise(name: nameField.text!, type: typeLabel.text!)
            exercise.add()
            return exercise
        }
        else{
            return Exercise.getObject(ck: Exercise.getCompoundKey(name: nameField.text!, type: typeLabel.text!))
        }
    }
    
    private func updateDiaryItem(exercise: Exercise){
        if countable{
            var count = 0
            if countField.text != "No sets"{
                count = Int(countField.text!)!
            }
            DiaryItem.update(uuid: diaryItem!.uuid, e: exercise, d: Duration(countPerSet: count), date: dateLabel.text!)
        }
        else{
            DiaryItem.update(uuid: diaryItem!.uuid, e: exercise, d: Duration(durationInSeconds: reverSecondsToString(time: durationLabel.text!)), date: dateLabel.text!)
        }
    }
    
    private func addDiaryItem(exercise: Exercise){
        if countable{
            diaryItem = DiaryItem(e: exercise, d: Duration(countPerSet: Int(countField.text!)), date: dateLabel.text!)
        }
        else{
            diaryItem = DiaryItem(e: exercise, d: Duration(durationInSeconds: reverSecondsToString(time: durationLabel.text!)), date: dateLabel.text!)
        }
        diaryItem!.add()
    }
    
    // MARK: - Actions
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        let isNameFieldEmpty = nameField.text == "" ? true : false
        saveButton.isHighlighted = isNameFieldEmpty
        saveButton.isEnabled = !isNameFieldEmpty
        
        if !isNameFieldEmpty{
            if let index = exerciseNames.firstIndex(of: nameField.text!){
                typeLabel.text = exercises[index].type
            }
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
        let exercise = getExercise()
        
        if diaryItem != nil{
            updateDiaryItem(exercise: exercise)
        }
        else{
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
        diaryItem!.exercise = newExercise.exercise
        diaryItem?.duration!.durationInSeconds = newExercise.durationInSeconds!.durationInSeconds
    }
}

// MARK: - UIPickerView
extension NewWorkoutPopupViewController:  UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case pickerViewTags.type.rawValue:
            return 1
        case pickerViewTags.duration.rawValue:
            return 2
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case pickerViewTags.type.rawValue:
            return types.count
            
        case pickerViewTags.duration.rawValue:
            return 60
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case pickerViewTags.type.rawValue:
            return types[row]
            
        case pickerViewTags.duration.rawValue:
            return String(row)
            
        default:
            return "unknown"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case pickerViewTags.type.rawValue:
            typeLabel.text = types[pickerView.selectedRow(inComponent: 0)]
            
        case pickerViewTags.duration.rawValue:
            durationLabel.text = SecondsToString(time: pickerView.selectedRow(inComponent: 0)*60 + pickerView.selectedRow(inComponent: 1))
            
        default:
            break
        }
        
    }
    
    
}
