//
//  Message.swift
//  neblinaAR
//
//  Created by Negar on 2020-03-19.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation

final class Message: Codable{
    var success:successStruct?
    var contents:replyContent?
    var baseurl:String
    var copyright:copyRightType
}

struct successStruct: Codable{
    var total:Int?
}

struct replyContent: Codable{
    var quotes:[Quote]?
}

struct Quote: Codable{
    var quote:String?
    var length:String?
    var author:String
    var tags:[String]
    var category:String?
    var language:String
    var date:String
    var permalink:String
    var id:String
    var background:String
    var title:String
}

struct copyRightType: Codable{
    var year:Int?
    var url:String
}

//{
//    "success": {
//        "total": 1
//    },
//    "contents": {
//        "quotes": [
//            {
//                "quote": "Positive anything is better than negative thinking.",
//                "length": "51",
//                "author": "Elbert Hubbard",
//                "tags": [
//                    "inspire",
//                    "positive-thinking"
//                ],
//                "category": "inspire",
//                "language": "en",
//                "date": "2020-05-17",
//                "permalink": "https://theysaidso.com/quote/elbert-hubbard-positive-anything-is-better-than-negative-thinking",
//                "id": "g3j5nQxVRTka7Sw3khgdRQeF",
//                "background": "https://theysaidso.com/img/qod/qod-inspire.jpg",
//                "title": "Inspiring Quote of the day"
//            }
//        ]
//    },
//    "baseurl": "https://theysaidso.com",
//    "copyright": {
//        "year": 2022,
//        "url": "https://theysaidso.com"
//    }
//}
