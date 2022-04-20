//
//  Constants.swift
//  workoutapp
//
//  Created by Negar Haghbin on 2022-04-08.
//  Copyright © 2022 Negar. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let images = ["markus-spiske-KWQ2kQtxiKE-unsplash", "victor-freitas-qZ-U9z4TQ6A-unsplash", "bruno-nascimento-PHIgYUGQPvU-unsplash", "x-N4QTBfNQ8Nk-unsplash", "marc-najera-Cj2d2IUEPDM-unsplash", "clique-images-hSB2HmJYaTo-unsplash", "engin-akyurt-yBwF4KOKwO4-unsplash", "tommy-boudreau-diO0a_ZEiEE-unsplash"]
}

struct NotificationNames {
    static let nameFieldChanged = NSNotification.Name(rawValue: "nameFieldChanged")
}

struct CellIdentifiers {
    static let badgeCellIdentifier = "badgeCellIdentifier"
    static let addWorkoutCell = "addWorkoutCell"
    static let diaryCellIdentifier = "diaryCell"
    static let interactionTableCell = "InteractionTableCell"
    static let routineCell = "RoutineCell"
    static let routineTableReuseIdentifier = "RoutineTableReuseIdentifier"
    static let videoTableViewCellIdentifier = "VideoTableViewCell"
}

struct SegueIdentifiers {
    static let oldWorkout = "oldWorkout"
    static let newWorkout = "newWorkout"
    static let showDiaryItem = "showDiaryItem"
    static let edit = "edit"
    static let showExercises = "showExercises"
    static let wellDone = "wellDone"
    static let startRoutine = "startRoutine"
    static let showExercise = "showExercise"
    static let start = "start"
}

struct ViewControllerIdentifiers {
}

struct ColorPalette {
    static let mainPink = UIColor(named: "mainPink")!
}
