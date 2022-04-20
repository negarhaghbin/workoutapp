//
//  OnboardingPage.swift
//  workoutapp
//
//  Created by Negar Haghbin on 2022-04-08.
//  Copyright © 2022 Negar. All rights reserved.
//

import Foundation

struct OnboardingPage {
    var title: String
    var subtitle: String
    var imageName: String
    
    static let allPages = [
        OnboardingPage(title: "GET DAILY REMINDERS", subtitle: "Set notifications for 3 types of reminders.", imageName: "notifications.png"),
        OnboardingPage(title: "KEEP A WORKOUT DIARY", subtitle: "Write down your workout diary at the end of each day.", imageName: "diary.png"),
        OnboardingPage(title: "EARN BADGES", subtitle: "Collect badges after reaching a new level of interaction with 5 mins!", imageName: "badges.png"),
        OnboardingPage(title: "WHAT SHOULD I CALL YOU?", subtitle: "", imageName: "nameImage.png"),
        OnboardingPage(title: "TIME BASED REMINDERS", subtitle: "It is recommended to do exercises at the same time everyday.", imageName: ""),
        OnboardingPage(title: "LOCATION BASED REMINDERS", subtitle: "How long after entering your usual place for starting 5 mins workout routines you want to be reminded to start working out?", imageName: ""),
        OnboardingPage(title: "ARE YOU READY?", subtitle: "You can always change notification preference in settings.", imageName: "start.png")
    ]
}
