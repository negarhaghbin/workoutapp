//
//  Message.swift
//  workoutapp
//
//  Created by Negar on 2020-03-19.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation

struct Message: Codable {
    var contents: respondContent?
}

struct respondContent: Codable {
    var quotes: [Quote]?
}

struct Quote: Codable {
    var quote: String?
    var author: String
}
