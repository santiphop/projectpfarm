//
//  Pig.swift
//  pjFarm
//
//  Created by Santiphop on 10/10/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class Pig: NSObject {
    var id:String
    var dateIn:Date
    var mother:String
    var father:String
    var gender:String
    
    init(id:String, date:Date, mother:String, father:String, gender:String) {
        self.id = id
        self.dateIn = date
        self.mother = mother
        self.father = father
        self.gender = gender
    }
    
    func injection() -> Date {
        return dateIn.addingTimeInterval(7)
    }
 
}
