//
//  AlertController+Image.swift
//  workoutapp
//
//  Created by Negar on 2020-06-11.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func imageWithSize(_ size: CGSize)->UIImage{
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return scaledImage
    }
}
extension UIAlertController{
    func addImage(image: UIImage){
        let maxSize = CGSize(width: 100, height: 100)
        let imageSize = image.size
        let ratio = maxSize.width / imageSize.width
        let scaledSize = CGSize(width: imageSize.width * ratio , height: imageSize.height * ratio)
        var resizedImage = image.imageWithSize(scaledSize)
        
        let left = (maxSize.width - resizedImage.size.width) / 2
        resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsets(top: 0,left: -left,bottom: 0,right: 0))
        
        let imageAction = UIAlertAction(title: "", style: .default, handler: nil)
        imageAction.isEnabled = false
        imageAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imageAction)
    }
}
