//
//  WorkData.swift
//  pjFarm
//
//  Created by Santiphop on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class WorkData: NSObject {
    static let shared: WorkData = WorkData()
    var works:[Work] = []
    let dateFormat = DateFormatter()

    
    func add(date:Date, type:Int, pigID:Int) {
        dateFormat.dateFormat = "yyyyMMdd"
        var isCreate = true
        for w in works {
            if w.workID.prefix(12).elementsEqual("\(dateFormat.string(from: date))W\(String(format: "%03d", type))") {
                isCreate = false
            }
        }
        let thisWork = Work(workDate: date, workTypeID: type, workPigID: pigID)
        thisWork.setWorkIDFormat()
        if isCreate {
            works.append(thisWork)
        }
        
    }
    
    func getAt(index:Int) -> Work {
        return works[index]
    }
    
    func generateWorkDateForMusao(date:Date, pigID:Int) -> [Date] {
        let addDate = [0, 7, 14, 21, 28, 32]
        var workDate:[Date] = []
        for i in 0...addDate.count - 1 {
            workDate.append(addDateComponent(date: date, intAdding: addDate[i]))
            self.add(date: workDate[i], type: i, pigID: pigID)
        }
        return workDate
    }
    
    private func addDateComponent(date:Date, intAdding:Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = intAdding
        let newDate = Calendar.current.date(byAdding: dateComponent, to: date)!
        return newDate
    }
    
    
    
}

class Work: NSObject {
    var workID:String = ""
    var workDate:Date
    var workTypeID:Int
    var workPigID:[Int] = []
    
    let dateFormat = DateFormatter()

    init(workDate:Date, workTypeID:Int, workPigID:Int) {
        self.workDate = workDate
        self.workTypeID = workTypeID
        self.workPigID.append(workPigID)
    }
    
    func setWorkIDFormat() {
        dateFormat.dateFormat = "yyyyMMdd"
        self.workID = "\(dateFormat.string(from: self.workDate))W\(String(format: "%03d", self.workTypeID))P\(self.workPigID)"
    }
}
