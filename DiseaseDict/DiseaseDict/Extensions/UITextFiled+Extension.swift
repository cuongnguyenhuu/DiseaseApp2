//
//  UITextFiled+Extension.swift
//  DiseaseDict
//
//  Created by Currie on 11/26/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func borderTextFieldStyle(){
        self.layer.cornerRadius = 10
//        self.layer.borderWidth = 2
//        self.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
        self.leftViewMode = .always
    }
}
