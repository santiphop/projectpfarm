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

    init(id:Int, primary:Int, secondary:Int, date:Date, work:Work) {
        self.primaryRound = primary
        self.secondaryRound = secondary
        super.init(id: id, date: date, work: work)
    }

}
