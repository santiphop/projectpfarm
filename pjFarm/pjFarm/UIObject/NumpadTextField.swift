//
//  DateTextField.swift
//  pjFarm
//
//  Created by Santiphop on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class NumpadTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addDoneTB()
        self.keyboardType = UIKeyboardType.numberPad
        //  remove cursor
        self.tintColor = UIColor.clear
        
    }
    
    func addDoneTB() {
        self.tintColor = UIColor.clear
        let onDone = (target: self, action: #selector(doneButtonTap))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTap() { self.resignFirstResponder()}
    
}
