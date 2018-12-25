//
//  Pig.swift
//  pjFarm
//
//  Created by Santiphop on 23/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class Pig: NSObject {
    var id = Int()
    var date = Date()
    var work:Work
    
    init(id:Int, date:Date, work:Work) {
        self.id = id
        self.date = date
        self.work = work
        self.work.date = work.generateWorkDate(date: date, fromIndex: 0)
    }
}
