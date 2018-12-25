//
//  PigMaepun.swift
//  pjFarm
//
//  Created by Santiphop on 23/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigMaepun: PigRound {
    
    init(id:Int, date:Date, work:Work) {
        super.init(id: id, primary: 1, secondary: 1, date: date, work: work)
    }
    
}
