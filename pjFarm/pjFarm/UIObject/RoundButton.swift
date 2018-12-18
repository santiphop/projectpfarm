//
//  RoundButton.swift
//  pjFarm
//
//  Created by Santiphop on 18/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 10
        
    }
}
