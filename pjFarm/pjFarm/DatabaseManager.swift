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

    var pigData = PigData()
    
    
    var currentID:Int = 0
    
    
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
        ref.child("หมู").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            for (key, _) in data! {
                if "\(key as! String)" != "currentID" {
                    self.pigList.append("\(key as! String)")
                }
            }
            print(self.pigList)
            print(self.pigList.count)
            
            for id in self.pigList {
                ////////// "หมูสาว" + id + "ประวัติ"
                let path = "หมู/\(id)/หมูสาว/ประวัติ"
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
        self.setUpCurrentID()

    }
    
    //  เลื่อนงานวันนี้ไปทำพรุ่งนี้
    func reportWorkForTomorrow(work:String, ids:[Int], bools:[Bool], date:Date) {
        let todayPath = "งาน/\(dateFormat.string(from: date))W/\(work)"
        let tomorrowPath = "งาน/\(dateFormat.string(from: addDateComponent(date: date, intAdding: 1)))W/ทั้งหมด/\(currentWork)"
        var index = 1
        for j in 0...bools.count-1 {
            let i = bools.count-1-j
            
            if bools[i] {
                print(ids[i])
                ref.child("\(todayPath)/\(index)").setValue(ids[i])
                ref.child("\(tomorrowPath)/\(tmrWorkIDCount)").setValue(ids[i])
                index += 1
                tmrWorkIDCount += 1
                print(workInfo[currentWork]?.count as Any)
                workInfo[currentWork]?.remove(at: i)
            }
        }
//        var pig:Pig
//        ref.child("งาน/\(dateFormat.string(from: date))W/\(work)/idenfier").observeSingleEvent(of: .value, with: { snapshot in
//            let id = snapshot.value as! String
//            let type = id.first!
//            let state = id.last!
//            var info : [Int:Pig]
//            if type == "1" {
//                info = self.pigData.pigGiltInfo
//            }
//            if type == "2" {
//                info = self.pigData.pigBreederInfo
//            }
//            if type == "3" {
//                info = self.pigData.pigFarrowInfo
//            }
//            if type == "4" {
//                info = self.pigData.pigWeanInfo
//            }
//            for i in 0...ids.count-1 {
//                if bools[i] {
//                    self.ref.child("งาน/\(self.dateFormat.string(from: date))W/\(work)/\(ids[i])")
//                } else {
//                    self.ref.child("งาน/\(self.dateFormat.string(from: date))W/\(work)/\(ids[i])").setValue("0")
//                }
//            }
//        })
        
        
    }
    
    //
    //  workID has 2 character
    //
    //  1st is pig's state
    //      1 = gilt
    //      2 = breeder
    //      3 = farrowing
    //      4 = weaning
    //
    //  2nd is pig's type work state
    //
    
    //  value is status of work
    //      0 = assigned
    //      1 = done
    //      2 = undone
    
    func assignWork(pig:Pig) {
        let workDate = pig.wDate
        let workName = pig.wName
        
        for i in 0...(workName.count) - 1 {
            ref.child("งาน/\(dateFormat.string(from: workDate[i]))W/\(workName[i])/identifier").setValue("\(pig.typeID)\(i)")
            ref.child("งาน/\(dateFormat.string(from: workDate[i]))W/\(workName[i])/\(pig.id)").setValue(0)

            
            if dateFormat.string(from: workDate[i]).elementsEqual(dateFormat.string(from: Date())) {
                if !workList.contains(workName[i]) {
                    workList.append(workName[i])
                    workInfo[workName[i]] = []
                    workInfo[workName[i]]?.append(pig.id)
                } else {
                    workInfo[workName[i]]?.append(pig.id)
                }
            }
        }
        
        
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
        let thisDate = dateFormat.string(from: date)
        ref.child("งาน/\(thisDate)W").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            
            if data != nil {
                for (key, _) in data! {
                    self.workList.append(key as! String)
                }
            }

            for workName in self.workList {
                let path = "งาน/\(thisDate)W/\(workName)"
                self.ref.child(path).observeSingleEvent(of: .value, with: { interSnapshot in
                    let thisWork = interSnapshot.value as? NSDictionary
                    self.workInfo[workName] = []
                    for (key, _) in thisWork! {
                        self.workInfo[workName]?.append(Int(key as! String)!)
                    }
                })
            }
        })
    }
    
}

/////     คอกอนุบาล  /////
extension DatabaseManager {
    
    func regisKG(id:String, date:Date) {
        let kindg = PigKinderGarten(id: Int(id)!, date: date)
        pigData.add(pig: kindg)

        ref.child("หมู/\(id)/สถานะ").setValue("แม่พันธุ์")
        
        ref.child("คอกคลอด/\(id)").observeSingleEvent(of: .value, with: { snapshot in
            let primaryCount = snapshot.childrenCount
            self.ref.child("คอกอนุบาล/\(id)/\(primaryCount)").setValue([
                "เข้าคอกอนุบาล": self.dateFormat.string(from: date),
                kindg.wName[0]: self.dateFormat.string(from: kindg.wDate[0]),
                kindg.wName[1]: self.dateFormat.string(from: kindg.wDate[1]),
                kindg.wName[2]: self.dateFormat.string(from: kindg.wDate[2]),
                kindg.wName[3]: self.dateFormat.string(from: kindg.wDate[3]),
            ])
        })
        
        assignWork(pig: kindg)
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
    
    
    
    func regisKK(id:String, dad:String, date:Date, all:Int, dead:Int, mummy:Int, male:Int, female:Int) {
        let remain = all-(dead+mummy)
        ref.child("หมู/\(id)/แม่พันธุ์/\(primaryState)/\(secondaryState)/ประวัติการทำคลอด").setValue([
            "วันคลอด":dateFormat.string(from: date),
            "จำนวนลูกทั้งหมด":all,
            "จำนวนลูกที่ตาย":dead,
            "จำนวนลูกที่พิการ":mummy,
            "จำนวนลูกที่เหลือ":remain,
            "จำนวนลูกที่เหลือเพศผู้":male,
            "จำนวนลูกที่เหลือเพศเมีย":female
        ])
        
        let kokklod = PigKokklod(
            all: all, dead: dead, mummy: mummy, remain: remain, male: male, female: female, id: Int(id)!, date: date
        )
        pigData.add(pig: kokklod)

        
        ref.child("หมู/\(id)/แม่พันธุ์/currentState").observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            let primary = data?["primary"] as! Int
            let secondary = data?["secondary"] as! Int
            let dateFormat = self.dateFormat
            
            print(primary)
            self.ref.child("หมู/\(id)/สถานะ").setValue("คอกคลอด")
            self.ref.child("หมู/\(id)/แม่พันธุ์/\(primary)/\(secondary)/คอกคลอด").setValue([
                "วันคลอด":dateFormat.string(from: date),
                "งาน":[
                    kokklod.wName[0]:dateFormat.string(from: kokklod.wDate[0]),
                    kokklod.wName[1]:dateFormat.string(from: kokklod.wDate[1]),
                    kokklod.wName[2]:dateFormat.string(from: kokklod.wDate[2])
                ]
            ])
            print(primary)

        })
        
        assignWork(pig: kokklod)
    }
}

/////     แม่พันธุ์     /////
extension DatabaseManager {
    
    
    func regisMP(date:Date, id:String) {
        let maepun = PigMaepun(id: Int(id)!, date: date)
        pigData.add(pig: maepun)

        ref.child("หมู/\(id)/สถานะ").setValue("แม่พันธุ์")
        ref.child("หมู/\(id)/แม่พันธุ์").setValue([
            "currentState":[
                "primary":1,
                "secondary":1
            ],
            "\(maepun.primaryRound)":[
                "\(maepun.secondaryRound)":[
                    "เป็นสัดรอบแรก":dateFormat.string(from: date),
                    
                ]
            ]
        ])
        for i in 0...maepun.wName.count-1 {
            ref.child("หมู/\(self.currentID)/แม่พันธุ์/\(maepun.primaryRound)/\(maepun.primaryRound)/งาน/\(maepun.wName[i])").setValue(dateFormat.string(from: maepun.wDate[i]))
        }
        assignWork(pig: maepun)

    }
}


/////     หมูสาว     /////
extension DatabaseManager {
    func setUpCurrentID() {
        ref.child("หมู").observeSingleEvent(of: .value, with: { snapshot in
            // Get data
            let data = snapshot.value as? NSDictionary
            let id = data?["currentID"] as? Int
            self.currentID = id!
            print("init in observeSingleEvent, currentID: \(self.currentID)")
        })
    }
    
    func regisMS(dad:String, mom:String, date:Date) -> Int {
        self.currentID += 1
        
        let musao = PigMusao(id: self.currentID, mother: mom, father: dad, date:date)
        
        pigData.add(pig: musao)
        
        ref.child("หมู/currentID").setValue(self.currentID)
        ref.child("หมู/\(self.currentID)/สถานะ").setValue("หมูสาว")
        ref.child("หมู/\(self.currentID)/หมูสาว/ประวัติ").setValue([
            "แม่พันธุ์":mom,
            "พ่อพันธุ์":dad,
            "วันแรกเข้า":dateFormat.string(from: date)
        ])
        for i in 0...musao.wName.count-1 {
            ref.child("หมู/\(self.currentID)/หมูสาว/งาน/\(musao.wName[i])").setValue(dateFormat.string(from: musao.wDate[i]))
        }
        
        assignWork(pig: musao)

        
        pigList.append("\(self.currentID)")
        pigInfo["\(self.currentID)"] = [mom, dad, dateFormat.string(from: date)]
        return self.currentID
    }

}
