//
//  UIButtonExtension.swift
//  workoutapp
//
//  Created by Negar Haghbin on 2022-04-08.
//  Copyright © 2022 Negar. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setCharacterSpacing(with string: String, color: UIColor = .white, spacing characterSpacing: CGFloat = 2, underlined: Bool = false, forState: State = .normal){
        let buttonStr = NSMutableAttributedString(string: string)
        if characterSpacing > 0 {
            buttonStr.addAttribute(.kern, value: characterSpacing, range: NSRange(location: 0, length: string.dropLast().utf16.count))
        }
        
        buttonStr.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: string.utf16.count))
        
        if underlined {
            buttonStr.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: string.utf16.count))
        }
        
        self.setAttributedTitle(buttonStr, for: forState)
    }
}
