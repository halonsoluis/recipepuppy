//
//  CustomAngleLabel.swift
//  Recipes
//
//  Created by Hugo Alonso on 24/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomAngleLabel: UILabel {
    @IBInspectable var angle: Int {
        get {
            return 0
        } set {
            let radians = CGFloat.pi * CGFloat(newValue) / CGFloat(180.0)
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
}
