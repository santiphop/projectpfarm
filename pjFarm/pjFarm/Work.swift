//
//  Work.swift
//  pjFarm
//
//  Created by Santiphop on 25/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class Work: NSObject {
    
    var typeID:String
    var name = [String]()
    var date = [Date]()
    var addDate = [Int]()
    
    init(typeID:String, name:[String], addDate:[Int]) {
        self.typeID = typeID
        self.name = name
        self.addDate = addDate
        super.init()
    }
    
    func generateSelf(date:Date) {
        self.date = self.generateWorkDate(date: date, fromIndex: 0)
    }
    
    
    func generateWorkDate(date:Date, fromIndex:Int) -> [Date] {
        var tmp = [Date]()
        var dateOfPigRegister = date
        //  minus date for reassignWork
        //  fromIndex = 0 from pig registration
        if fromIndex != 0 {
            for i in 0...fromIndex-1 {
                dateOfPigRegister = (addDateComponent(date: date, intAdding: -addDate[i]))
            }
        }
        for i in fromIndex...addDate.count - 1 {
            tmp.append(addDateComponent(date: dateOfPigRegister, intAdding: addDate[i]))
        }
        return tmp
    }
    
    
    
    
}

