//
//  UIViewExtension.swift
//  workoutapp
//
//  Created by Negar on 2020-07-06.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var round: Bool {
        get {
            return layer.cornerRadius == frame.size.height / 2.0
        }
        set {
            layer.cornerRadius = newValue ? frame.size.height / 2.0 : cornerRadius
        }
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
