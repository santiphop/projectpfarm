//
//  Pig.swift
//  pjFarm
//
//  Created by Santiphop on 10/10/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class PigMusao: Pig {
    
    var mother:String
    var father:String
    
    init(id:Int, mother:String, father:String, date:Date) {
        self.mother = mother
        self.father = father
        super.init(
            id: id,
            typeID: "1",
            date: date,
            work: [
                "ถ่ายพยาธิ", "วัคซีนอหิวาห์", "วัคซีนพาร์โว", "วัคซีนพิษสุนัขบ้าเทียม", "วัคซีนปากเท้าเทียม", "วัคซีน PRRS"
            ],
            addDate: [0, 7, 14, 21, 28, 32]
        )
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
