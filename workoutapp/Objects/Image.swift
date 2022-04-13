//
//  Image.swift
//  workoutapp
//
//  Created by Negar on 2019-11-13.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

struct Image {
    let url: URL
    
    static func loadRoutineSectionHeaderImages()->[Image] {
        var images: [Image] = []
        let names = [ "totalBody", "upperBody", "abs", "lowerBody"]

        for name in names {
            guard let urlPath = Bundle.main.path(forResource: name, ofType: "png") else {
                debugPrint(name + " not found")
                return []
            }
            let url = URL(fileURLWithPath: urlPath)
            let image = Image(url: url)
            images.append(image)
        }
        return images
    }
    
}
