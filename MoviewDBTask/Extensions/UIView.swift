//
//  UIView.swift
//  Technician
//
//  Created by ws-7 on 09/07/18.
//  Copyright © 2018 Epic Group LLC. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
   
    
    func makeCornersRound(radius:CGFloat){
        self.layer.cornerRadius = self.frame.height/radius
    }
    
    func applyShadow(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: -2, height: -2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
    }
    
    func applyBorder(){
        self.layer.borderWidth = 0.4;
        self.layer.cornerRadius = 8.0;
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
}
