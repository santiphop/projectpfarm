//
//  Pig.swift
//  pjFarm
//
//  Created by Santiphop on 10/10/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigMusao: NSObject {
    var id:String
    var idFormat:PigIDFormat
    var dateIn:Date = Date()
    var mother:String
    var father:String
    var gender:String
    var vaccine:[Date] = []
    
    
    
    
    init(id:String, idFormat:PigIDFormat, date:Date, mother:String, father:String, gender:String) {
        self.id = id
        self.idFormat = idFormat
        self.dateIn = date
        self.mother = mother
        self.father = father
        self.gender = gender
    }
    
    func setVaccine(date:Date) {
        for i in 1...5 {
            vaccine[i] = addDateComponent(date: date, intAdding: i*7)
        }
    }
    
    private func addDateComponent(date:Date, intAdding:Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = intAdding
        let newDate = Calendar.current.date(byAdding: dateComponent, to: date)!
        return newDate
    }
    
    
 
}

protocol PigIDFormat {
    func getFormat(date: Date) -> String
}

class PJFarmIDFormat: PigIDFormat {
    func getFormat(date: Date) -> String {
        let newDate = changeToBuddhist(date: date)
        return newDate
    }
    
    private func changeToBuddhist(date:Date) -> String {
        let dF = DateFormatter()
        dF.dateFormat = "YY"
        
        let newdF = Int(dF.string(from: Date()))! + 43
        return String(newdF)
    }
}
