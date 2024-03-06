//
//  UIView+Extensions.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 3/1/24.
//

import Foundation
import UIKit


extension UIView{
    
    func applyCornerRadius(radius :CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
