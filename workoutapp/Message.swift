//
//  Message.swift
//  neblinaAR
//
//  Created by Negar on 2020-03-19.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation

final class Message: Codable{
    var contents:replyContent?
}

struct replyContent: Codable{
    var quotes:[Quote]?
}

struct Quote: Codable{
    var quote:String?
    var author:String
}
