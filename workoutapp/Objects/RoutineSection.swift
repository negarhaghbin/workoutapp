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
    var image: Image
    var exercises: [AppExercise]
    var repetition: Int = 1
    
    init(title: String, image: Image, exercises: [AppExercise]) {
        self.title = title
        self.image = image
        self.exercises = exercises
        self.repetition = 1
    }
    
    func setRepetition(r: Int) {
        self.repetition = r
    }
    
    func getDuration() -> Int {
        var duration = 0
        
        for exercise in exercises {
            duration += exercise.durationInSeconds?.durationInSeconds ?? 0
        }
        return duration
    }
    
    func getEquipments() -> [String] {
        var equipments: [String] = []
        let filteredExercises = exercises.filter({!$0.getEquipments().isEmpty})
        for exercise in filteredExercises {
            let newEquipments = exercise.getEquipments().filter({!equipments.contains($0)})
            equipments.append(contentsOf: newEquipments)
        }
        return equipments
    }
    
    func getDescription() -> String {
        var equipmentsString = ""
        let equipments = self.getEquipments()
        if equipments.isEmpty {
            equipmentsString = "No Equipment"
        } else {
            var temp = ""
            for equipment in equipments {
                temp += "\(equipment) "
            }
            equipmentsString = temp
        }
        
        return "  \(secondsToMSString(time: self.getDuration())) \u{2022} \(equipmentsString)"
    }
    
    class func getRoutineSections() -> [RoutineSection] {
        var sections: [RoutineSection] = []
        let images = Image.loadRoutineSectionHeaderImages()
        let titles = [ExerciseType.total.rawValue, ExerciseType.upper.rawValue, ExerciseType.abs.rawValue, ExerciseType.lower.rawValue]
        for (index, title) in titles.enumerated(){
            sections.append(RoutineSection(title: title, image: images[index], exercises: []))
        }
        let exercises = AppExercise.loadExercises()
        for exercise in exercises {
            for section in sections {
                if section.title == exercise.exercise?.type {
                    section.exercises.append(exercise)
                }
            }
        }
        return sections
    }
}
