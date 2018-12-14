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
    var ref:DatabaseReference
    let dateFormat = DateFormatter()

    
    var currentIDMS:Int = 0
    var musaoWorkDate:[Date] = []
    var musaoWorkIDCount:[Int] = []
    var musaoWorkString:[String] = [
        "ถ่ายพยาธิ", "วัคซีนอหิวาห์", "วัคซีนพาร์โว", "วัคซีนพิษสุนัขบ้าเทียม", "วัคซีนปากเท้าเทียม", "วัคซีน PRRS"
    ]
    
    var currentIDMP:Int = 0
    var maepunWorkDate:[Date] = []
    var maepunWorkIDCount:[Int] = []
    var maepunWorkString:[String] = [
        "ตรวจสัดครั้งที่1", "ตรวจสัดครั้งที่2", "ตรวจสัดครั้งที่3", "ตรวจท้อง"
    ]
    
    
    var currentWork:String = ""
    
    
    
    
    var workList = [String]()
    var details = [String:[Int]]()
    
    var report = [String:[Bool]]()
    
    

    
    
    
    
    
    
    
    
    init() {
        dateFormat.dateFormat = "yyyyMMdd"
        FirebaseApp.configure()
        ref = Database.database().reference()
        
        //  set up musao
        self.generateWorkDateForMusao(date: Date())
        self.generateWorkIDCountForMusao()
        
        
        
        //  set up maepun
        
        
        //  set up หมูสาว's currentID
        self.setUpCurrentIDMS()
        
        
    }
    
    func reportDetail(bools:[Bool]) {
        report[currentWork] = bools
        print(report)
    }
    
    
    func setUpFirstInitIDMP(id:Int) {
        ref.child("แม่พันธุ์/\(id)/currentState").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            let primary = data?["primary"] as? Int
            let secondary = data?["secondary"] as? Int
        })
    }
    
//    func generateWorkDateForMaepun(date:Date) -> [Date] {
//        let addDate = [0, 7, 14, 21, 28, 32]
//        var workDate:[Date] = []
//        for i in 0...addDate.count - 1 {
//            workDate.append(addDateComponent(date: date, intAdding: addDate[i]))
//        }
//        return workDate
//    }
//
//    func generateWorkIDCountForMaepun() -> [Int] {
//        var workIDCount:[Int] = []
//        for i in 0...5 {
//            ref.child("งาน/\(musaoWorkDate[i])/ทั้งหมด/ฉีดวัคซีน").observeSingleEvent(of: .value, with: { snapshot in
//                // Get data
//                workIDCount.append(Int(snapshot.childrenCount) + 1)
//            })
//        }
//        return workIDCount
//    }
    

    
    
    
    func turnIntoMom(date:Date, id:String) {
        let checkRut1 = addDateComponent(date: date, intAdding: 21)
        let checkRut2 = addDateComponent(date: date, intAdding: 42)
        let checkRut3 = addDateComponent(date: date, intAdding: 63)
        let checkPregnent = addDateComponent(date: date, intAdding: 84)

        ref.child("แม่พันธุ์/\(id)").setValue([
            "1":[
                "เป็นสัดรอบแรก":dateFormat.string(from: date),
                "1":[
                    "วันตรวจสัดครั้งที่":[
                        "1":[
                            "วันกำหนด":dateFormat.string(from: checkRut1)
                        ],
                        "2":[
                            "วันกำหนด":dateFormat.string(from: checkRut2)
                        ],
                        "3":[
                            "วันกำหนด":dateFormat.string(from: checkRut3)
                        ]
                    ],
                    "วันตรวจท้อง":[
                        "วันกำหนด":dateFormat.string(from: checkPregnent)
                    ]
                ]
            ],
            "currentState":[
                "primary":1,
                "secondary":1
            ]
        ])
    }
    
    func assignWork(index:Int, pigID:Int) {
        ref.child("งาน/\(dateFormat.string(from: musaoWorkDate[index]))W/ทั้งหมด/\(musaoWorkString[index])/\(musaoWorkIDCount[index])").setValue(pigID)
        musaoWorkIDCount[index] += 1
    }
    
    private func addDateComponent(date:Date, intAdding:Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = intAdding
        let newDate = Calendar.current.date(byAdding: dateComponent, to: date)!
        return newDate
    }
    
    func get1912work() {
        ref.child("งาน/20181219W/ทั้งหมด").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            
            for (key, _) in data! {
                self.workList.append("\(key as! String)")
            }
            
            for workName in self.workList {
                let path = "งาน/20181219W/ทั้งหมด/\(workName)"
                self.report[workName] = []
                self.ref.child(path).observeSingleEvent(of: .value, with: { snapshot in
                    let count = snapshot.childrenCount
                    var array:[Int] = []
                    for i in 1...Int(count) {
                        self.ref.child("\(path)/\(i)").observeSingleEvent(of: .value, with: { snapshot in
                            let id = snapshot.value
                            array.append(id as! Int)
                            self.details[workName] = array
                            self.report[workName]?.append(false)
                        })
                    }
                })
            }
        })
    }
    
    func println()  {
        print(self.details)
    }
    
    
}


/////     หมูสาว     ///////
extension DatabaseManager {
    func setUpCurrentIDMS() {
        ref.child("หมูสาว").observeSingleEvent(of: .value, with: { snapshot in
            // Get data
            let data = snapshot.value as? NSDictionary
            let id = data?["currentID"] as? Int
            self.currentIDMS = id!
            print("init in observeSingleEvent, currentID: \(self.currentIDMS)")
        })
    }
    
    func generateWorkDateForMusao(date:Date) {
        let addDate = [0, 7, 14, 21, 28, 32]
        musaoWorkDate.removeAll()
        for i in 0...addDate.count - 1 {
            musaoWorkDate.append(addDateComponent(date: date, intAdding: addDate[i]))
        }
    }
    
    func generateWorkIDCountForMusao() {
        musaoWorkIDCount.removeAll()
        for i in 0...5 {
            ref.child("งาน/\(musaoWorkDate[i])W/ทั้งหมด/\(musaoWorkString[i])").observeSingleEvent(of: .value, with: { snapshot in
                // Get data
                self.musaoWorkIDCount.append(Int(snapshot.childrenCount) + 1)
            })
        }
    }
    
    func regisMS(dad:String, mom:String, gender:String, date:Date) -> Int {
        self.currentIDMS += 1
        ref.child("หมูสาว/currentID").setValue(self.currentIDMS)
        
        self.generateWorkDateForMusao(date: date)
        
        ref.child("หมูสาว/\(self.currentIDMS)").setValue([
            "แม่พันธุ์":mom,
            "พ่อพันธุ์":dad,
            "เพศ":gender,
            "วันแรกเข้า":dateFormat.string(from: date),
            "วันถ่ายพยาธิ":[
                "วันกำหนด":dateFormat.string(from: musaoWorkDate[0])
            ],
            "วัคซีน":[
                "1":[
                    "โรค":"อหิวาห์",
                    "วันกำหนด":dateFormat.string(from: musaoWorkDate[1])
                ],
                "2":[
                    "โรค":"พาร์โว",
                    "วันกำหนด":dateFormat.string(from: musaoWorkDate[2])
                ],
                "3":[
                    "โรค":"พิษสุนัขบ้าเทียม",
                    "วันกำหนด":dateFormat.string(from: musaoWorkDate[3])
                ],
                "4":[
                    "โรค":"ปากเท้าเทียม",
                    "วันกำหนด":dateFormat.string(from: musaoWorkDate[4])
                ],
                "5":[
                    "โรค":"PRRS",
                    "วันกำหนด":dateFormat.string(from: musaoWorkDate[5])
                ],
            ]
            ])
        
        assignWork(index: 0, pigID: self.currentIDMS)
        for i in 1...5 {
            assignWork(index: i, pigID: self.currentIDMS)
        }
        
        return self.currentIDMS
    }
}
