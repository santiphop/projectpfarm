//
//  NonCursorTextField.swift
//  pjFarm
//
//  Created by Santiphop on 11/1/2562 BE.
//  Copyright © 2562 iOS Dev. All rights reserved.
//

import UIKit

//  UNUSED CLASS
class NonCursorTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //  remove cursor
        self.tintColor = UIColor.clear
        
    }
}
