//
//  UIButtonExtension.swift
//  calculadoraTareaCenfotec
//
//  Created by Felipe Ramirez Vargas on 11/2/21.
//  Copyright © 2021 com.framirez. All rights reserved.
//

// Idea got it in Github, credits to MouroDev
import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton{

        
    // Brilla
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
    
    func selectOperation(_ selected: Bool) {
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ? orange : .white, for: .normal)
    }

}
