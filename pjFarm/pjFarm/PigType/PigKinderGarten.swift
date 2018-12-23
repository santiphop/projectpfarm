//
//  PigKinderGarten.swift
//  pjFarm
//
//  Created by Santiphop on 23/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigKinderGarten: PigRound {
    
    init(id:Int, date:Date) {
        super.init(
            id: id,
            typeID: "4",
            primary: 1,
            secondary: 1,
            date: date,
            work: [
                "วัคซีนอหิวาห์รอบที่1", "วัคซีนพิษสุนัขบ้าเทียมรอบที่1", "วัคซีนอหิวาห์รอบที่2", "วัคซีนพิษสุนัขบ้าเทียมรอบที่2"
            ],
            addDate: [7, 14, 21, 28]
        )
    }
    
    
    
}
