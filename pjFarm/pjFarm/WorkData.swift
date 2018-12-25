//
//  WorkData.swift
//  pjFarm
//
//  Created by Santiphop on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkData: NSObject {
    var works = [String:Work]()

    func add(work:Work) {
        works[work.typeID] = work

    }
    
    func getAt(type:String) -> Work {
        return works[type]!
    }
    
}

class Work: NSObject {
    
    var typeID:String
    var name = [String]()
    var date = [Date]()
    var addDate = [Int]()
    
    let dateFormat = DateFormatter()

    init(typeID:String, name:[String], addDate:[Int], data:WorkData) {
        self.typeID = typeID
        self.name = name
        self.addDate = addDate
        super.init()
        data.add(work: self)
    }

    
    func generateWorkDate(date:Date, fromIndex:Int) -> [Date] {
        var tmp = [Date]()
        var new = date
        if fromIndex != 0 {
            for i in 0...fromIndex-1 {
                new = (addDateComponent(date: date, intAdding: -addDate[i]))
            }
        }
        for i in fromIndex...addDate.count - 1 {
            tmp.append(addDateComponent(date: new, intAdding: addDate[i]))
        }
        return tmp
    }
    
    
    
    
}
