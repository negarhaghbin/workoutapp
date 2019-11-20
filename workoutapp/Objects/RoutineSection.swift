//
//  RoutineSection.swift
//  workoutapp
//
//  Created by Negar on 2019-11-19.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class RoutineSection: NSObject {
    var title: String
    var image : Image
    var exercises : [ExerciseModel]
    
    init(title: String, image: Image, exercises:[ExerciseModel]) {
        self.title = title
        self.image = image
        self.exercises = exercises
        super.init()
    }
    
    func getDescription()->String{
        var duration = 0
        var equipments : [String] = []
        var equipmentsString = ""
        for exercise in exercises{
            duration += exercise.durationS
            if (exercise.getEquipments() != []){
                for equipment in exercise.getEquipments(){
                    if (!equipments.contains(equipment)){
                        equipments.append(equipment)
                    }
                }
            }
        }
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
        return "  \(duration) seconds \u{2022} \(equipmentsString)"
        
    }
    
    class func getRoutineSections()->[RoutineSection]{
        var sections : [RoutineSection] = []
        let images = Image.loadRoutineSectionHeaders()
        let titles=["Total Body", "Upper Body", "Abs", "Lower Body"]
        for (index, title) in titles.enumerated(){
            sections.append(RoutineSection(title: title, image: images[index], exercises: []))
        }
        let exercises = ExerciseModel.loadExercises()
        for exercise in exercises{
            for (index,section) in sections.enumerated(){
                if section.title == exercise.section{
                    sections[index].exercises.append(exercise)
                }
            }
        }
        return sections
    }
}
