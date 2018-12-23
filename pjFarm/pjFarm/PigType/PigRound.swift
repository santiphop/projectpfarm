//
//  PigWithState.swift
//  pjFarm
//
//  Created by Santiphop on 23/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

//  abstract class
class PigRound: Pig {
    var primaryRound = Int()
    var secondaryRound = Int()

    init(id:Int, typeID:String, primary:Int, secondary:Int, date:Date, work:[String], addDate:[Int]) {
        self.primaryRound = primary
        self.secondaryRound = secondary
        super.init(
            id: id,
            typeID: typeID,
            date: date,
            work: work,
            addDate: addDate
        )
    }

}
