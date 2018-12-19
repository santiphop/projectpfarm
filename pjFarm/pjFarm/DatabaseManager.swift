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
    
    var maepunWorkDate:[Date] = []
    var maepunWorkIDCount:Int = 0
    var maepunWorkString:[String] = [
        "ตรวจสัดครั้งที่1", "ตรวจสัดครั้งที่2", "ตรวจสัดครั้งที่3", "ตรวจท้อง", "ขึ้นคลอด", "กำหนดคลอด"
    ]
    
    
    var kokklodWorkDate:[Date] = []
    var kokklodIDCount:[Int] = []
    var kokklodWorkString:[String] = [
        "ตอนตัวผู้-ตัดหูตัวเมีย", "ตัดเขี้ยวและหาง", "ถ่ายพยาธิ-กำหนดหย่านม"
    ]
    
    var kindergartenWorkDate:[Date] = []
    var kindergartenIDCount:[Int] = []
    var kindergartenWorkString:[String] = [
        "วัคซีนอหิวาห์รอบที่1", "วัคซีนพิษสุนัขบ้าเทียมรอบที่1", "วัคซีนอหิวาห์รอบที่2", "วัคซีนพิษสุนัขบ้าเทียมรอบที่2"
    ]
    
    var pigList = [String]()
    var pigInfo = [String:[String]]()
    
    var currentWork:String = ""
    
    var workList = [String]()
    var workInfo = [String:[Int]]()
    
    var tmrWorkIDCount:Int = 0
    
    var primaryState:Int = 0
    var secondaryState:Int = 0
    
    //  เฉพาะหมูสาว
    func getAllPig() {
        ref.child("หมูสาว").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            for (key, _) in data! {
                if "\(key as! String)" != "currentID" {
                    self.pigList.append("\(key as! String)")
                }
            }
//            print(self.pigList)
//            print(self.pigList.count)
            
            for id in self.pigList {
                ////////// "หมูสาว" + id + "ประวัติ"
                let path = "หมูสาว/\(id)/ประวัติ"
                self.ref.child(path).observeSingleEvent(of: .value, with: { snapshot in
                    let data = snapshot.value as? NSDictionary
                    let momID = data?["แม่พันธุ์"] as! String
                    let dadBreed = data?["พ่อพันธุ์"] as! String
                    let dateIn = data?["วันแรกเข้า"] as! String
                    self.pigInfo[id] = []
                    self.pigInfo[id]?.append(momID)
                    self.pigInfo[id]?.append(dadBreed)
                    self.pigInfo[id]?.append(dateIn)
                })
            }
        })
        
    }
    
    
    init() {
        dateFormat.dateFormat = "yyyyMMdd"
        FirebaseApp.configure()
        ref = Database.database().reference()
        
        //  set up musao
        self.setUpCurrentIDMS()
        self.generateWorkDateForMusao(date: Date())
        self.generateWorkIDCountForMusao()
        
        //  set up maepun
        self.generateWorkDateForMaepun(date: Date())
        self.generateWorkIDCountForMaepun(index: 0) // เฉพาะงานแรก: "ตรวจสัดครั้งที่1"
        
        //  set up kokklod
        self.generateWorkDateForKokKlod(date: Date())
        self.generateWorkIDCountForKokKlod()
        
        //  set up kindergarten
        self.generateWorkDateForKindergarten(date: Date())
        self.generateWorkIDCountForKindergarten()
    }
    
    //  เลื่อนงานไปทำพรุ่งนี้
    func reportWorkForTomorrow(ids:[Int], bools:[Bool], date:Date) {
        let todayPath = "งาน/\(dateFormat.string(from: date))W/งานค้าง/\(currentWork)"
        let tomorrowPath = "งาน/\(dateFormat.string(from: addDateComponent(date: date, intAdding: 1)))W/ทั้งหมด/\(currentWork)"
        var index = 1
        for j in 0...bools.count-1 {
            var i = bools.count-1-j
            if bools[i] {
                print(ids[i])
                ref.child("\(todayPath)/\(index)").setValue(ids[i])
                ref.child("\(tomorrowPath)/\(tmrWorkIDCount)").setValue(ids[i])
                index += 1
                tmrWorkIDCount += 1
                print(workInfo[currentWork]?.count)
                workInfo[currentWork]?.remove(at: i)
            }
        }
    }
    
    func assignWork(date:Date, work:String, IDCount:Int, pigID:Int) -> Int {
        ref.child("งาน/\(dateFormat.string(from: date))W/ทั้งหมด/\(work)/\(IDCount)").setValue(pigID)
        //  append the getAllWork()
        if dateFormat.string(from: date).elementsEqual(dateFormat.string(from: Date())) {
            if !workList.contains(work) {
                workList.append(work)
                workInfo[work] = []
                workInfo[work]?.append(pigID)
            } else {
                workInfo[work]?.append(pigID)
            }
        }
        return IDCount + 1
    }
    
    func initcheck()  {
        print(self.workInfo)
    }
    
    private func addDateComponent(date:Date, intAdding:Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = intAdding
        let newDate = Calendar.current.date(byAdding: dateComponent, to: date)!
        return newDate
    }
}

/////     รายงาน    /////
extension DatabaseManager {
    func getAllWorkFrom(date:Date) {
        //  append workList
        //  append workInfo
        ref.child("งาน/\(dateFormat.string(from: date))W/ทั้งหมด").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary

            for (key, _) in data! {
                self.workList.append("\(key as! String)")
            }

            for workName in self.workList {
                let path = "งาน/\(self.dateFormat.string(from: date))W/ทั้งหมด/\(workName)"
                self.ref.child(path).observeSingleEvent(of: .value, with: { snapshot in
                    let count = snapshot.childrenCount
                    var array:[Int] = []
                    for i in 1...Int(count) {
                        self.ref.child("\(path)/\(i)").observeSingleEvent(of: .value, with: { snapshot in
                            let id = snapshot.value
                            array.append(id as! Int)
                            self.workInfo[workName] = array
                        })
                    }
                })
            }
        })
    }
    
    func generateIDCountForTomorrowWork() {
        ref.child("งาน/\(dateFormat.string(from: addDateComponent(date: Date(), intAdding: 1)))W/ทั้งหมด/\(currentWork)").observeSingleEvent(of: .value, with: { snapshot in
            self.tmrWorkIDCount = Int(snapshot.childrenCount) + 1
        })
    }
}

/////     คอกอนุบาล  /////
extension DatabaseManager {
    func generateWorkDateForKindergarten(date:Date) {
        let addDate = [7, 14, 21, 28]
        kindergartenWorkDate.removeAll()
        for i in 0...addDate.count - 1 {
            kindergartenWorkDate.append(addDateComponent(date: date, intAdding: addDate[i]))
        }
    }
    
    func generateWorkIDCountForKindergarten() {
        kindergartenIDCount.removeAll()
        for i in 0...3 {
            ref.child("งาน/\(dateFormat.string(from: kindergartenWorkDate[i]))W/ทั้งหมด/\(kindergartenWorkString[i])").observeSingleEvent(of: .value, with: { snapshot in
                // Get data
                self.kindergartenIDCount.append(Int(snapshot.childrenCount) + 1)
            })
        }
    }
    
    func regisKG(id:String, date:Date) {
        ref.child("คอกคลอด/\(id)").observeSingleEvent(of: .value, with: { snapshot in
            let primaryCount = snapshot.childrenCount
            self.ref.child("คอกอนุบาล/\(id)/\(primaryCount)").setValue([
                "เข้าคอกอนุบาล": self.dateFormat.string(from: date),
                "\(self.kindergartenWorkString[0])": self.dateFormat.string(from: self.kindergartenWorkDate[0]),
                "\(self.kindergartenWorkString[1])": self.dateFormat.string(from: self.kindergartenWorkDate[1]),
                "\(self.kindergartenWorkString[2])": self.dateFormat.string(from: self.kindergartenWorkDate[2]),
                "\(self.kindergartenWorkString[3])": self.dateFormat.string(from: self.kindergartenWorkDate[3]),
                ])
            
            for i in 0...3 {
                self.kindergartenIDCount[i] = self.assignWork(date: self.kindergartenWorkDate[i], work: self.kindergartenWorkString[i], IDCount: self.kindergartenIDCount[i], pigID: Int(id)!)
            }
        })
    }
}

/////     คอกคลอด   /////
extension DatabaseManager {
    //  get primary, secondary from ID
    func getMaepunCurrentStateFrom(id:String) {
        ref.child("แม่พันธุ์/\(id)/currentState").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            if data != nil {
                self.primaryState = data?["primary"] as! Int
                self.secondaryState = data?["secondary"] as! Int
            }
        })
    }
    
    func generateWorkDateForKokKlod(date:Date) {
        let addDate = [3, 7, 24]
        kokklodWorkDate.removeAll()
        for i in 0...addDate.count - 1 {
            kokklodWorkDate.append(addDateComponent(date: date, intAdding: addDate[i]))
        }
    }
    
    func generateWorkIDCountForKokKlod() {
        kokklodIDCount.removeAll()
        for i in 0...2 {
            ref.child("งาน/\(dateFormat.string(from: kokklodWorkDate[i]))W/ทั้งหมด/\(kokklodWorkString[i])").observeSingleEvent(of: .value, with: { snapshot in
                // Get data
                self.kokklodIDCount.append(Int(snapshot.childrenCount) + 1)
            })
        }
    }
    
    func regisKK(id:String, date:Date) {
        self.generateWorkDateForKokKlod(date: date)
        
        ref.child("คอกคลอด/\(id)/\(primaryState)").setValue([
            "secondary":secondaryState,
            "วันคลอด":dateFormat.string(from: date),
            "\(kokklodWorkString[0])":dateFormat.string(from: kokklodWorkDate[0]),
            "\(kokklodWorkString[1])":dateFormat.string(from: kokklodWorkDate[1]),
            "\(kokklodWorkString[2])":dateFormat.string(from: kokklodWorkDate[2])
        ])
        
        for i in 0...1 {
            kokklodIDCount[i] = assignWork(date: kokklodWorkDate[i], work: kokklodWorkString[i], IDCount: kokklodIDCount[i], pigID: Int(id)!)
            
        }
    }
    
    func writeKlodHistory(id:String, dad:String, date:Date, all:Int, dead:Int, mummy:Int, male:Int, female:Int) {
        ref.child("แม่พันธุ์/\(id)/\(primaryState)/\(secondaryState)/ประวัติการทำคลอด").setValue([
            "วันคลอด":dateFormat.string(from: date),
            "จำนวนลูกทั้งหมด":all,
            "จำนวนลูกที่ตาย":dead,
            "จำนวนลูกที่พิการ":mummy,
            "จำนวนลูกที่เหลือ":all-(dead+mummy),
            "จำนวนลูกที่เหลือเพศผู้":male,
            "จำนวนลูกที่เหลือเพศเมีย":female
        ])
        regisKK(id: id, date: date)
    }
}

/////     แม่พันธุ์     /////
extension DatabaseManager {
    func generateWorkDateForMaepun(date:Date) {
        let addDate = [21, 42, 63, 84, 109, 114]
        maepunWorkDate.removeAll()
        for i in 0...addDate.count - 1 {
            maepunWorkDate.append(addDateComponent(date: date, intAdding: addDate[i]))
        }
    }
    
    func generateWorkIDCountForMaepun(index:Int) {
        ref.child("งาน/\(dateFormat.string(from: maepunWorkDate[index]))W/ทั้งหมด/\(maepunWorkString[index])").observeSingleEvent(of: .value, with: { snapshot in
            // Get data
            self.maepunWorkIDCount = (Int(snapshot.childrenCount) + 1)
        })
    }
    
    func regisMP(date:Date, id:String) {
        ref.child("แม่พันธุ์/\(id)").setValue([
            "1":[
                "เป็นสัดรอบแรก":dateFormat.string(from: date),
                "1":[
                    "งาน":[
                        "วันตรวจสัดครั้งที่":[
                            "1":dateFormat.string(from: maepunWorkDate[0]),
                            "2":dateFormat.string(from: maepunWorkDate[1]),
                            "3":dateFormat.string(from: maepunWorkDate[2])
                        ],
                        "\(maepunWorkString[3])":dateFormat.string(from: maepunWorkDate[3]),
                        "\(maepunWorkString[4])":dateFormat.string(from: maepunWorkDate[4]),
                        "\(maepunWorkString[5])":dateFormat.string(from: maepunWorkDate[5])
                    ]
                ]
            ],
            "currentState":[
                "primary":1,
                "secondary":1
            ]
        ])
        ref.child("หมูสาว/\(id)/ประวัติ/สถานะ").setValue("แม่พันธุ์")
        maepunWorkIDCount = assignWork(date: maepunWorkDate[0], work: maepunWorkString[0], IDCount: maepunWorkIDCount, pigID: Int(id)!)
    }
}


/////     หมูสาว     /////
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
            ref.child("งาน/\(dateFormat.string(from: musaoWorkDate[i]))W/ทั้งหมด/\(musaoWorkString[i])").observeSingleEvent(of: .value, with: { snapshot in
                // Get data
                self.musaoWorkIDCount.append(Int(snapshot.childrenCount) + 1)
            })
        }
    }
    
    
    func regisMS(dad:String, mom:String, date:Date) -> Int {
        self.currentIDMS += 1
        ref.child("หมูสาว/currentID").setValue(self.currentIDMS)
        
//        self.generateWorkDateForMusao(date: date)
        
        ref.child("หมูสาว/\(self.currentIDMS)").setValue([
            "ประวัติ":[
                "แม่พันธุ์":mom,
                "พ่อพันธุ์":dad,
                "วันแรกเข้า":dateFormat.string(from: date)
            ],
            "งาน":[
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
            ]
        ])
        
        for i in 0...5 {
            musaoWorkIDCount[i] = assignWork(date: musaoWorkDate[i], work: musaoWorkString[i], IDCount: musaoWorkIDCount[i], pigID: self.currentIDMS)
            
        }
        
        return self.currentIDMS
    }
}
