//
//  RoutineSection.swift
//  workoutapp
//
//  Created by Negar on 2019-11-19.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

enum ExerciseType : String {
    case total = "Total Body"
    case upper = "Upper Body"
    case abs = "Abs"
    case lower = "Lower Body"
}

class RoutineSection: NSObject {
    var title: String
    var image : Image
    var exercises : [ExerciseModel]
    var repetition : Int
    
    init(title: String, image: Image, exercises:[ExerciseModel]) {
        self.title = title
        self.image = image
        self.exercises = exercises
        self.repetition = 3
        super.init()
    }
    
    func setRepetition(r: Int){
        self.repetition = r
    }
    
    func getDuration()->Int{
        var duration = 0
        for exercise in exercises{
            duration += exercise.durationS
        }
        return duration
    }
    
    func getEquipments()->Array<String>{
        var equipments : [String] = []
        for exercise in exercises{
            if (exercise.getEquipments() != []){
                for equipment in exercise.getEquipments(){
                    if (!equipments.contains(equipment)){
                        equipments.append(equipment)
                    }
                }
            }
        }
        return equipments
    }
    
    func getDescription()->String{
        var equipmentsString = ""
        let equipments = self.getEquipments()
        if (equipments == []){
            equipmentsString = "No Equipments"
        }
        else{
            var temp = ""
            for equipment in equipments{
                temp += "\(equipment) "
            }
            equipmentsString = temp
        }
        print(self.getDuration())
        return "  \(SecondsToString(time: self.getDuration())) \u{2022} \(equipmentsString)"
    }
    
    class func getRoutineSections()->[RoutineSection]{
        var sections : [RoutineSection] = []
        let images = Image.loadRoutineSectionHeaders()
        let titles=[ExerciseType.total.rawValue, ExerciseType.upper.rawValue, ExerciseType.abs.rawValue, ExerciseType.lower.rawValue]
        for (index, title) in titles.enumerated(){
            sections.append(RoutineSection(title: title, image: images[index], exercises: []))
        }
        let exercises = ExerciseModel.loadExercises()
        for exercise in exercises{
            for section in sections{
                if section.title == exercise.section{
                    section.exercises.append(exercise)
                }
            }
        }
        return sections
    }
    
    class func getCollectionRoutineSections()->[RoutineSection]{
        var sections : [RoutineSection] = []
        let images = Image.loadRoutineSectionHeaders()
        let titles=[ExerciseType.total, ExerciseType.upper, ExerciseType.abs, ExerciseType.lower]
        for (index, title) in titles.enumerated(){
            sections.append(RoutineSection(title: title.rawValue, image: images[index], exercises: []))
        }
        let exercises = ExerciseModel.loadExercises()
        for exercise in exercises{
            for section in sections{
                if section.title == exercise.section{
                    if exercise.bothSides{
                        let exerciseLeft = ExerciseModel(value: exercise)
                        exerciseLeft.title += "(left)"
                        section.exercises.append(exerciseLeft)
                        let exerciseRight = ExerciseModel(value: exercise)
                        exerciseRight.title += "(right)"
                        section.exercises.append(exerciseRight)
                    }
                    else{
                       section.exercises.append(exercise)
                    }
                    
                }
            }
        }
        return sections
    }
}
