//
//  PigMaepun.swift
//  pjFarm
//
//  Created by Santiphop on 23/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigMaepun: PigRound {
    
    init(id:Int, date:Date) {
        super.init(
            id: id,
            typeID: "2",
            primary: 1,
            secondary: 1,
            date: date,
            work: [
                "ตรวจสัดครั้งที่1", "ตรวจสัดครั้งที่2", "ตรวจสัดครั้งที่3", "ตรวจท้อง", "ขึ้นคลอด", "กำหนดคลอด"
            ],
            addDate: [21, 42, 63, 84, 109, 114]
        )
    }
    
}
