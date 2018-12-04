//
//  DatabaseManager.swift
//  pjFarm
//
//  Created by Santiphop on 28/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
//    static let shared: DatabaseManager = DatabaseManager()
    var ref:DatabaseReference
    var currentIDMS : Int = 0
    let dateFormat = DateFormatter()
    var currentDate = Date()
    
    
    init() {
        dateFormat.dateFormat = "yyyyMMdd"
        FirebaseApp.configure()
        ref = Database.database().reference()
        ref.child("หมูสาว").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get User data
            let datas = snapshot.value as? NSDictionary
            let id = datas?["currentID"] as? Int
            
            self.currentIDMS = id!
            print("init in observeSingleEvent, currentID: \(self.currentIDMS)")
            
        })
        
    }
    
    func regisMS(dad:String, mom:String, gender:String, date:Date) -> Int {
        let newID = String(currentIDMS + 1)
        var dateComp1 = DateComponents()
        var dateComp2 = DateComponents()
        var dateComp3 = DateComponents()
        var dateComp4 = DateComponents()
        var dateComp5 = DateComponents()
        
        dateComp1.day = 7
        dateComp2.day = 14
        dateComp3.day = 21
        dateComp4.day = 28
        dateComp5.day = 35
        
        let vaccine1 = Calendar.current.date(byAdding: dateComp1, to: date)!
        let vaccine2 = Calendar.current.date(byAdding: dateComp2, to: date)!
        let vaccine3 = Calendar.current.date(byAdding: dateComp3, to: date)!
        let vaccine4 = Calendar.current.date(byAdding: dateComp4, to: date)!
        let vaccine5 = Calendar.current.date(byAdding: dateComp5, to: date)!

        ref.child("หมูสาว/\(newID)").setValue([
            "แม่พันธุ์":mom,
            "พ่อพันธุ์":dad,
            "เพศ":gender,
            "วันแรกเข้า":dateFormat.string(from: date),
            "วัคซีน":[
                "อหิวาห์":[
                    "วันกำหนดฉีด":dateFormat.string(from: vaccine1)
                ],
                "พาร์โว":[
                    "วันกำหนดฉีด":dateFormat.string(from: vaccine2)
                ],
                "พิษสุนัขบ้าเทียม":[
                    "วันกำหนดฉีด":dateFormat.string(from: vaccine3)
                ],
                "ปากเท้าเทียม":[
                    "วันกำหนดฉีด":dateFormat.string(from: vaccine4)
                ],
                "PRRS":[
                    "วันกำหนดฉีด":dateFormat.string(from: vaccine5)
                ],
            ]
            ])
        ref.child("หมูสาว/currentID").setValue(Int(newID))
        self.currentIDMS = Int(newID)!
        return Int(newID)!
    }
    
    func readWork(date:Date) -> [Int] {
        var tmp:[Int] = []
        ref.child("งาน/\(dateFormat.string(from: date))").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get User data
            let datas = snapshot.value as? NSDictionary
            var i = 1
            
            while true {
                let workID = datas?["\(i)"] as? Int
                if workID != nil {
                    print(workID!)
                    tmp.append(workID!)
                    i += 1
                    continue
                }
                break
            }
        })
        print(tmp)
        return tmp
    }
}
