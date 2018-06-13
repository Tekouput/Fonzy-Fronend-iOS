//
//  textFieldExtension.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 8/20/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import Foundation



extension UITextField{
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
