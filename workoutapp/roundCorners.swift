//
//  roundCorners.swift
//  workoutapp
//
//  Created by Negar on 2020-07-06.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
