//
//  PigKokklod.swift
//  pjFarm
//
//  Created by Santiphop on 23/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigKokklod: PigRound {
    var all:Int
    var dead:Int
    var mummy:Int
    var remain:Int
    var remainMale:Int
    var remainFemale:Int
    
    init(all:Int, dead:Int, mummy:Int, remain:Int, male:Int, female:Int, id:Int, date:Date, work:Work) {
        self.all = all
        self.dead = dead
        self.mummy = mummy
        self.remain = remain
        self.remainMale = male
        self.remainFemale = female
        
        super.init(id: id, primary: 1, secondary: 1, date: date, work: work)
    }
    
    
}
